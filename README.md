# Caelestia-Gamemode  
Its Auto Gamemode script for [Caelestia Dots](https://github.com/caelestia-dots/shell).   

Read bellow, for configuring instructions.

# Preview



https://github.com/user-attachments/assets/51299a28-fa8a-4724-b3e3-e8ae551776a8


  
# Install  
```
git clone https://github.com/FrederikFazberovic/Caelestia-Gamemode.git
cd Caelestia-Gamemode
chmod +x ./install.sh
./install.sh
```  
Thats all!  
  
# Configuring  

Add process names or runners (e.g. `minecraft`, `steam-launch-wrapper`) to `~/.config/caelestia-gamemode/patterns.conf`, one per line. Some common processes come preconfigured.

To find a process name, run:

```
ps aux | grep -E ""
```

Put the pattern between the quotes to filter the output.

# Uninstalling  

cd into cloned `Caelestia-Gamemode` folder, and run
```
chmod +x ./uninstall.sh
./uninstall.sh
```
