module.exports = {
  "autodiscover": false,
  "allowPostUpgradeCommandTemplating": true,
  "automerge": true,

  "repositories": [
    "wesley-dean-flexion/busybox-jq-latest"
  ],

  "packageRules": [
    {
      "matchUpdateTypes": ["minor", "patch", "pin", "digest"],
      "automerge": true
    }
  ],

  "labels": [
    "dependencies"
  ]

};
