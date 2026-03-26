#!/usr/bin/env osascript -l JavaScript

function run() {
  var musicSites =
    /youtube\.com\/watch|music\.youtube\.com|soundcloud\.com|bandcamp\.com|tidal\.com|open\.spotify\.com/;

  if (
    !Application("System Events")
      .processes.whose({ name: "Google Chrome" })
      .length
  )
    return "";

  var chrome = Application("Google Chrome");
  var wins = chrome.windows();

  for (var w = 0; w < wins.length; w++) {
    var tabs = wins[w].tabs();
    for (var i = 0; i < tabs.length; i++) {
      try {
        var url = tabs[i].url();
        if (musicSites.test(url)) {
          return tabs[i].title();
        }
      } catch (e) {}
    }
  }

  return "";
}
