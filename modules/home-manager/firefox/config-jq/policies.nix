{ lib, ... }:
{
  ExtensionUpdate = false;
  "3rdparty".Extensions = {
    "ublock-origin".adminSettings = {
      userSettings = rec {
        uiTheme = "dark";
        uiAccentCustom = true;
        uiAccentCustom0 = "#8300ff";
        cloudStorageEnabled = lib.mkForce false;
        importedLists = [
          "https://filters.adtidy.org/extension/ublock/filters/3.txt"
          "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
        ];
        externalLists = lib.concatStringsSep "\n" importedLists;
      };
      selectedFilterLists = [
        "CZE-0"
        "adguard-generic"
        "adguard-annoyance"
        "adguard-social"
        "adguard-spyware-url"
        "easylist"
        "easyprivacy"
        "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
        "plowe-0"
        "ublock-abuse"
        "ublock-badware"
        "ublock-filters"
        "ublock-privacy"
        "ublock-quick-fixes"
        "ublock-unbreak"
        "urlhaus-1"
      ];
    };
  };
}
