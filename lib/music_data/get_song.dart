class GetSong {
  static String mSongName = '';
  static String mSongFileName = '';

  String getSongName() {
    return mSongName;
  }

  void setSongName(String SongName) {
    mSongName = SongName;
  }

  String getSongFileName() {
    return mSongFileName;
  }

  setSongFileName(String SongFileName) {
    mSongFileName = SongFileName;
  }

  int getSongNameLenth() {
    return mSongName.length;
  }

  List<String> getSongNameChar() {
    return mSongName.split('');
  }
}
