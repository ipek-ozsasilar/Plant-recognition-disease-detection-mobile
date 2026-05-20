package com.ipekozsasilar.bitirme_mobile

import android.content.ClipData
import android.content.ContentValues
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "com.ipekozsasilar.bitirme_mobile/downloads"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "savePdf" -> {
                        val bytes = call.argument<ByteArray>("bytes")
                        val name = call.argument<String>("fileName")
                        if (bytes == null || name.isNullOrBlank()) {
                            result.error("INVALID", "bytes and fileName required", null)
                            return@setMethodCallHandler
                        }
                        try {
                            val path = savePdfToPublicDownloads(bytes, name)
                            result.success(path)
                        } catch (e: Exception) {
                            result.error("SAVE_FAILED", e.message, null)
                        }
                    }
                    "openPdf" -> {
                        val uriStr = call.argument<String>("uri")
                        if (uriStr.isNullOrBlank()) {
                            result.error("INVALID", "uri required", null)
                            return@setMethodCallHandler
                        }
                        runOnUiThread {
                            try {
                                openPdfUri(uriStr)
                                result.success(true)
                            } catch (e: Exception) {
                                result.error("OPEN_FAILED", e.message, null)
                            }
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun openPdfUri(uriStr: String) {
        val uri: Uri = if (uriStr.startsWith("content://")) {
            Uri.parse(uriStr)
        } else {
            val file = File(uriStr)
            FileProvider.getUriForFile(
                applicationContext,
                "${applicationContext.packageName}.fileprovider",
                file,
            )
        }
        val viewIntent = Intent(Intent.ACTION_VIEW).apply {
            setDataAndType(uri, "application/pdf")
            addFlags(
                Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_ACTIVITY_NEW_TASK,
            )
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                clipData = ClipData.newRawUri("pdf", uri)
            }
        }
        val pm = packageManager
        val matches = pm.queryIntentActivities(
            viewIntent,
            PackageManager.MATCH_DEFAULT_ONLY,
        )
        for (info in matches) {
            grantUriPermission(
                info.activityInfo.packageName,
                uri,
                Intent.FLAG_GRANT_READ_URI_PERMISSION,
            )
        }
        val launchIntent = if (matches.isEmpty()) {
            Intent(Intent.ACTION_VIEW).apply {
                setDataAndType(uri, "*/*")
                addFlags(
                    Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_ACTIVITY_NEW_TASK,
                )
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    clipData = ClipData.newRawUri("pdf", uri)
                }
            }
        } else {
            viewIntent
        }
        val chooser = Intent.createChooser(launchIntent, "PDF").apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        startActivity(chooser)
    }

    private fun savePdfToPublicDownloads(bytes: ByteArray, fileName: String): String {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val resolver = applicationContext.contentResolver
            val values = ContentValues().apply {
                put(MediaStore.Downloads.DISPLAY_NAME, fileName)
                put(MediaStore.Downloads.MIME_TYPE, "application/pdf")
                put(MediaStore.Downloads.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
                put(MediaStore.Downloads.IS_PENDING, 1)
            }
            val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
                ?: throw IllegalStateException("MediaStore insert failed")
            resolver.openOutputStream(uri).use { stream ->
                stream?.write(bytes) ?: throw IllegalStateException("Cannot open output stream")
            }
            values.clear()
            values.put(MediaStore.Downloads.IS_PENDING, 0)
            resolver.update(uri, values, null, null)
            return uri.toString()
        }
        @Suppress("DEPRECATION")
        val dir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
        if (!dir.exists()) {
            dir.mkdirs()
        }
        val file = File(dir, fileName)
        file.writeBytes(bytes)
        return file.absolutePath
    }
}
