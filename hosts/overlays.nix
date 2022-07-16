final: prev: {
  discord = prev.discord.overrideAttrs (
    # This overlay will pull the latest version of Discord
    _: {
      src = builtins.fetchTarball {
        url = "https://discord.com/api/download?platform=linux&format=tar.gz";
        sha256 = "1bhjalv1c0yxqdra4gr22r31wirykhng0zglaasrxc41n0sjwx0m";
      };
      version = "custom";
    }
  );
  vscode = let
    vscode-insider = prev.vscode.override {
      isInsiders = true;
    };
  in
    vscode-insider.overrideAttrs (oldAttrs: rec {
      src = builtins.fetchTarball {
        url = "https://update.code.visualstudio.com/latest/linux-x64/insider";
        sha256 = "0dqs12zflrdn9kni5wjag6d3599gnkxhayhcf93pcyw70y3ryi05";
      };
      version = "latest";
    });
}
