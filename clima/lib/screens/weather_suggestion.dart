String getSuggestionMessage(String description, double temp) {
  String suggestionMessage = "";

  if (description.contains('rain')) {
    suggestionMessage = "It's rainy! Don't forget to carry an umbrella.";
  } else if (description.contains('sun') || description.contains('clear')) {
    if (temp > 30) {
      suggestionMessage =
          "It's sunny and hot! Stay hydrated and wear sunscreen.";
    } else if (temp > 20) {
      suggestionMessage =
          "It's sunny with mild weather! Enjoy your day outdoors.";
    } else {
      suggestionMessage = "It's sunny but cool! Consider a light jacket.";
    }
  } else if (description.contains('cloud')) {
    suggestionMessage = "It's cloudy! Perfect weather for a walk.";
  } else if (description.contains('snow')) {
    suggestionMessage = "It's snowy! Dress warmly and stay safe.";
  } else if (description.contains('storm') ||
      description.contains('thunder')) {
    suggestionMessage =
        "There's a storm! Stay indoors and avoid outdoor activities.";
  } else if (description.contains('fog') || description.contains('mist')) {
    suggestionMessage = "It's foggy! Drive carefully and stay safe.";
  } else if (description.contains('wind')) {
    suggestionMessage =
        "It's windy! Secure loose items and wear a windbreaker.";
  } else if (description.contains('hail')) {
    suggestionMessage = "Hailstorm! Stay indoors to avoid any harm.";
  } else if (description.contains('tornado')) {
    suggestionMessage = "Tornado warning! Seek shelter immediately!";
  } else if (description.contains('dust')) {
    suggestionMessage = "Dusty conditions! Use a mask and protect your eyes.";
  } else {
    suggestionMessage = "Be prepared for anything! Enjoy your day.";
  }

  return suggestionMessage;
}
