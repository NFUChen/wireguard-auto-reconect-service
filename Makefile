# Makefile for deploying WireGuard ping monitor script

# Variables
SCRIPT_NAME = wg_ping.py
SCRIPT_PATH = ./$(SCRIPT_NAME)  # Update this path to your script's location
INSTALL_PATH = /usr/local/bin/$(SCRIPT_NAME)
SYSTEMD_SERVICE_NAME = wireguard_ping.service
SYSTEMD_PATH = /etc/systemd/system/$(SYSTEMD_SERVICE_NAME)

# Installation directory for systemd service
SYSTEMD_DIR = /etc/systemd/system

# Copy the script to /usr/local/bin
install-script:
	@echo "Copying the script to /usr/local/bin ..."
	sudo cp $(SCRIPT_PATH) $(INSTALL_PATH)
	sudo chmod +x $(INSTALL_PATH)
	@echo "Script installed to $(INSTALL_PATH)"

# Deploy the systemd service
deploy-systemd:
	@echo "Creating systemd service at $(SYSTEMD_PATH) ..."
	sudo cp $(SYSTEMD_SERVICE_NAME) $(SYSTEMD_DIR)
	sudo systemctl daemon-reload
	sudo systemctl enable $(SYSTEMD_SERVICE_NAME)
	sudo systemctl start $(SYSTEMD_SERVICE_NAME)
	@echo "Systemd service deployed and started."

# Clean up installed files
clean:
	@echo "Removing script and systemd service ..."
	sudo rm -f $(INSTALL_PATH)
	sudo rm -f $(SYSTEMD_PATH)
	@echo "Cleaned up."

# Full installation (script + systemd)
install: install-script deploy-systemd
	@echo "Installation complete!"

# Uninstall (script + systemd)
uninstall: clean
	@echo "Uninstallation complete!"
