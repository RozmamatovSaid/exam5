enum VideoStatus { 
  korilmadi, 
  korilyapti, 
  korildi 
}

String videoStatusToString(VideoStatus status) {
  switch (status) {
    case VideoStatus.korilmadi:
      return 'korilmadi';
    case VideoStatus.korilyapti:
      return 'korilyapti';
    case VideoStatus.korildi:
      return 'korildi';
  }
}

VideoStatus videoStatusFromString(String status) {
  switch (status) {
    case 'korilmadi':
      return VideoStatus.korilmadi;
    case 'korilyapti':
      return VideoStatus.korilyapti;
    case 'korildi':
      return VideoStatus.korildi;
    default:
      return VideoStatus.korilmadi;
  }
}