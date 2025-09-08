String formatStopwatchInMinutesSeconds(Duration duration) {
  StringBuffer buffer = StringBuffer();

  if (duration.isNegative) buffer.write("-");

  //Minutes
  buffer.write(duration.inMinutes.remainder(60).abs().toString().padLeft(2, "0"));

  buffer.write(":");

  //Seconds
  buffer.write(duration.inSeconds.remainder(60).abs().toString().padLeft(2, "0"));

  return buffer.toString();
}