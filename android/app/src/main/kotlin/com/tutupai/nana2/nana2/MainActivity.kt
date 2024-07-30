package com.tutupai.nana2.nana2

import android.media.AudioManager
import android.media.session.MediaSession
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    // 使用 by lazy 来进行延迟初始化
    private val audioManager: AudioManager by lazy { getSystemService(AUDIO_SERVICE) as AudioManager }
    private val mediaSession: MediaSession by lazy { MediaSession(this, "MyMediaSession") }

    // 创建 AudioFocusChangeListener 对象
    private val afChangeListener = object : AudioManager.OnAudioFocusChangeListener {
        override fun onAudioFocusChange(focusChange: Int) {
            when (focusChange) {
                AudioManager.AUDIOFOCUS_LOSS_TRANSIENT -> {
                    // Pause playback
                }
                AudioManager.AUDIOFOCUS_GAIN -> {
                    // Resume playback
                }
                AudioManager.AUDIOFOCUS_LOSS -> {
                    // Stop playback and release resources
                    audioManager.abandonAudioFocus(this)
                    mediaSession.release()
                }
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        mediaSession.isActive = true

        val result = audioManager.requestAudioFocus(
            afChangeListener,
            AudioManager.STREAM_MUSIC,
            AudioManager.AUDIOFOCUS_GAIN
        )

        if (result == AudioManager.AUDIOFOCUS_REQUEST_GRANTED) {
            // Focus gained, start playback
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        audioManager.abandonAudioFocus(afChangeListener)
        mediaSession.release()
    }
}
