import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerManager {
    static final AudioPlayer audioPlayer = AudioPlayer();
    ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: []);

    Future<List<SongInfo>> _getSongs() async {
        FlutterAudioQuery audioQuery = FlutterAudioQuery();
        return await audioQuery.getSongs();
    } 

    setAudioSource() async {        
        List<SongInfo> songs = await _getSongs();      

        if (songs.isNotEmpty) {
            for (SongInfo song in songs) {
                playlist.add(AudioSource.uri(Uri.parse(song.uri)));
            }
            await audioPlayer.setAudioSource(playlist);
        } else {
            await audioPlayer.setUrl('https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_500KB_MP3.mp3');
        }
    }

    void playAudio(int audioIndex) {
        audioPlayer.seek(Duration.zero, index: audioIndex);
        audioPlayer.play();
    }

    void playAudioPlayer() {
        audioPlayer.play();
    }

    void pauseAudioPlayer() {
        audioPlayer.pause();
    }

    void setVolume(double volume) {
        audioPlayer.setVolume(volume);
    }

    bool isPlaying() {
        return audioPlayer.playing;
    }

    getAudioSource() {
        return audioPlayer.audioSource;
    }
}


