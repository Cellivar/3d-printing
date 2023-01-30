# UP Studio3 Configuration Settings

The UP Studio3 configuration window (the left side of the screen with all the settings) has hard to discover behavior. These notes are meant to help make that behavior more clear.

Note that this document uses some non-Tiertime language to describe some features that seem to lack official names.

## Enabling all settings

If you're reading this you should enable expert view to view all of the settings. This disables the wizard-driven interface elements and makes the interface more complex to interact with, but more predictable in general.

1. Open the preferences menu and enabled 'Advanced UI', otherwise you can't see these settings.
2. Click on the large gear icon to edit the primary configuration.
3. Click on the configuration expertiese level button (defaults to 'basic') until it says 'expert'.

You can now see and modify all settings.

![image](https://user-images.githubusercontent.com/1441553/215379988-4d66c93d-4248-4de8-99f5-93bf81bcf1fe.png)

## General theory

* Everything in UP Studio3 is either a config input or an algorithm of some sort that uses those inputs.
* There is a primary configuration that all operations within UP Studio3 inherit. 
* Each loaded model has its own configuration that overrides the primary configuration.
* Each loaded model can have slice configurations which override the settings for specific layers within the model.
* The UI doesn't show which one you're looking at when you're editing each config, it just hides the not-relevant settings from you.

![image](https://user-images.githubusercontent.com/1441553/215395961-578fbaf4-4d57-4a52-bb10-cb6f35ce8e62.png)

## Primary global configuration

When you first install Up Studio3 it will prompt you for a printer to use. This will load a 'default global configuration' for that printer that will be used for all operations.

Note: For the Cetus2 you need to download and import a primray configuration file [from the Cetus website](https://www.cetus3d.com/software/).

![image](https://user-images.githubusercontent.com/1441553/215395334-59374e2b-75a9-4546-87e8-7e326500a2f9.png)

### Import, export and format

The primary configuration can be imported and exported, such as if you want to transfer between computers. 

The config format is json with what appears to be a VERY raw serialization format. I haven't done any exploring of the raw config format other than to observe that it's not well laid out for automation or editing in other applications.

### Primary-only settings

The printer tab only works for the primary config, other config layers don't let you modify the printer config.

## Model configuration

## Slice configuration

The slice configuration lets you override settings for individual layers. 

For example, you can use a slice config to disable part cooling for layer 1 to improve bed adhesion and keep it enabled for all other layers.
