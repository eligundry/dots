#!/usr/bin/env osascript -l JavaScript

// Finds the Chrome tab playing music and focuses it (window + tab + app).
// Mirrors the site list in chrome-now-playing.js.

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
        if (musicSites.test(tabs[i].url())) {
          wins[w].activeTabIndex = i + 1;
          wins[w].index = 1;
          chrome.activate();
          return tabs[i].title();
        }
      } catch (e) {}
    }
  }

  return "";
}
