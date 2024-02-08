import 'package:intl/intl.dart' ;


String formatDateTime(DateTime datetime){
  DateTime now = DateTime.now(); 
  Duration difference = now.difference(datetime); 
  if(difference.inSeconds < 60){
    return "Just now"; 
  }else if(difference.inMinutes < 60){
    return "${difference.inMinutes} min ago";
  }else if(difference.inHours < 24){
    return "${difference.inHours} hours ago";
  }else if(difference.inDays < 30){
    return "${difference.inDays} days ago";
  }else if(difference.inDays < 365){
    int months =now.month - datetime.month + 12 * (now.year- datetime.year);
    return "$months months ago";
  }else{
    return "${now.year - datetime.year} years ago";
  }

  
}



String getMessageTime(DateTime dateTime) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(dateTime);

  if (difference.inDays == 0) {
    // Same day
    return  DateFormat('HH:mm').format(dateTime);
  } else if (difference.inDays == 1) {
    // Yesterday
    return 'Yesterday ' + DateFormat('HH:mm').format(dateTime);
    
  } else if (difference.inDays < 7) {
    // Within a week
    return DateFormat('EEEE').format(dateTime);
  } else if (difference.inDays < 30) {
    // Within a month
    return DateFormat('dd MMM').format(dateTime);
  } else if (difference.inDays < 365) {
    // Within a year
    return DateFormat('yyyy-MM-dd').format(dateTime);
  } else {
    // More than a year
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }
}