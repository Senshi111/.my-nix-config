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
  vscode = prev.vscode.overrideAttrs (oldAttrs: rec {
      src = builtins.fetchTarball {
        url = "https://update.code.visualstudio.com/latest/linux-x64/stable";
        sha256 = "16cddiixip2yvpvzx202damgs1rs2rswfh9ls7illkgisdpkn1b1";
      };
      version = "latest";
    });
}
