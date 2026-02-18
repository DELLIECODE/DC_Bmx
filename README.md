# BMX Script

Script FiveM permettant aux joueurs d'utiliser un item BMX pour spawner et ranger leur vélo en jeu — ESX + ox_inventory + ox_target.

---

## Fonctionnalités

- Utilisation de l'item `bmx` pour sortir son vélo
- Spawn devant le joueur avec animation
- Ramassage via ox_target pour ranger le BMX dans l'inventaire
- Les BMX du monde ouvert (non spawnés par un joueur) sont également ramassables
- Suppression automatique du BMX si le joueur déconnecte sans le ranger
- Sécurité anti-abus : le netId du véhicule est validé côté serveur

---

## Prérequis

- [`es_extended`](https://github.com/esx-framework/esx_core)
- [`ox_inventory`](https://github.com/overextended/ox_inventory)
- [`ox_target`](https://github.com/overextended/ox_target)
- [`ox_lib`](https://github.com/overextended/ox_lib)

---

## Installation

1. Place le dossier dans `resources/`
2. Ajoute dans `server.cfg` :

```
ensure ox_lib
ensure ox_inventory
ensure ox_target
ensure es_extended
ensure DC_Bmx
```

3. Ajoute l'item `bmx` dans la config de ton `ox_inventory` :

```lua
['bmx'] = {
    label  = 'BMX',
    weight = 5000,
    stack  = false,
}
```

4. Donne l'item à un joueur pour tester :

```
/giveitem [id] bmx 1
```

---

## Structure des fichiers

```
bmx/
├── fxmanifest.lua
├── client/
│   └── client.lua
└── server/
    └── server.lua
```

---

## Sécurité

- Le serveur vérifie que le joueur possède l'item avant de déclencher le spawn
- Le `netId` du BMX est stocké côté serveur à la session du joueur
- Lors du ramassage, le serveur valide que le `netId` envoyé correspond bien au BMX de ce joueur — impossible de supprimer le véhicule d'un autre joueur
- Si le retrait d'item échoue après le spawn, le véhicule est annulé côté client

---

## Licence

MIT — libre à utiliser, modifier et redistribuer.

## DISCORD 

https://discord.gg/XnkrNnqFtK
