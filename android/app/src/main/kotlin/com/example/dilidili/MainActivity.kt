package com.example.dilidili

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.graphics.BitmapFactory
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity: FlutterActivity() {
    private val CHANNEL = "app.clipboard"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "copyImage") {
                val imageData = call.argument<ByteArray>("imageData")
                if (imageData != null) {
                    val success = copyImageToClipboard(imageData)
                    if (success) {
                        result.success("success")
                    } else {
                        result.error("COPY_FAILED", "复制图片失败", null)
                    }
                } else {
                    result.error("INVALID_ARGUMENT", "No image data provided", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun copyImageToClipboard(imageData: ByteArray): Boolean {
        return try {
            val bitmap = BitmapFactory.decodeByteArray(imageData, 0, imageData.size)
            val clipboard = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
            val tempFile = File(cacheDir, "temp_clipboard.png")
            val fos = FileOutputStream(tempFile)
            bitmap.compress(android.graphics.Bitmap.CompressFormat.PNG, 100, fos)
            fos.flush()
            fos.close()

            val uri = androidx.core.content.FileProvider.getUriForFile(
                this,
                "$packageName.fileprovider",
                tempFile
            )

            val clip = ClipData.newUri(contentResolver, "Image", uri)
            clipboard.setPrimaryClip(clip)
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
}
