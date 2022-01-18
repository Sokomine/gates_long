# Gates Long

This is a mod for Minetest.

Adds gates that are wider than the default gates, making it easier to get mobs to pass through them.

The gates respect the `enable_fence_tall` setting, making it possible to stop mobs jumping over them.

A setting allows the gates to automatically close after a certain number of seconds.

Gates are automatically added for all wood types, by looking for any registered nodes:
* in the `wood` group
* that are  a full cube node (`drawtype` is 'normal')

## Crafting

```
steel ingot - wood - steel ingot
(nothing)   - wood - (nothing)
```
