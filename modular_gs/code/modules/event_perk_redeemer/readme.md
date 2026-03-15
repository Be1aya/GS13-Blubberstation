# Event perk redeemer

This module allows admins to add redeemable event perks, allowing players to obtain their event rewards without admin intervention. It is separated into 3 verbs:

## Redeem event perk

Available in the OOC tab, this verb allows players to see the perks they have, their contents, expiry date, and allows them to redeem them. Right now, the perk contents spawn directly under the player.

## Event perk maker

Available in the admin tab in the stat panel, in the event section, this verb allows admins to create new event perks and modify existing ones.

### perk name

The perk's name serves as it's indentifier - trying to create 2 perks with the same name will cause the second one to overwrite the first.

### description

The description of the perk, which can be empty, contain flavor text, or information as to where the perk was obtained.

### items

The first field allows you to input the typepath to the item you want to add to the perk. You have to input in the exact path in its entirety, and there is no search function. The amount field can be left empty, and it will default to 1. Once you add the item, it will be added to a list where you can view the added items, their amount, and remove them.

### ckeys

Much like the item field, this will add ckeys to a list that will be displayed in the menu, from which they can be removed. The ckey inputted can be the player's username, or proper ckey, which in both cases will be converted to a proper ckey.

### expiry date

The expiry date of the perk in a DDMMYYYY format. It is fairly naive, and inputting dates like 99.03.2025 is possible - the perk will expire on 01.04.2025.

## Event perk manager

This TGUI menu allows admins to see ALL existing event perks, delete, redeem and modify them. The "edit" option will open a event perk maker menu with pre-filled info from the perk.

# Additional notes

There are currently no locks on players being able to redeem their perks outside of their ckeys. There is an intention to patch it in the future.
