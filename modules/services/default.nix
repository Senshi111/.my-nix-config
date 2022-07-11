#
#  Services
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ home.nix
#   └─ ./modules
#       └─ ./services
#           └─ default.nix *
#               └─ ...
#

[
  ./flameshot.nix
  ./udiskie.nix
]

# Media is pulled from desktop default config
