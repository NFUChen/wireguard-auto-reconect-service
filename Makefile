# Makefile for deploying WireGuard ping monitor script

# Variables
SCRIPT_NAME = wg_ping.py
SCRIPT_PATH = ./$(SCRIPT_NAME)  # Update this path to your script's location
INSTALL_PATH = /usr/local/bin/$(SCRIPT_NAME)
SYSTEMD_SERVICE_NAME = wireguard_ping.service
SYSTEMD_PATH = /etc/systemd/system/$(SYSTEMD_SERVICE_NAME)
CONFIG_NAME = wg_ping.conf
CONFIG_PATH = ./$(CONFIG_NAME)
CONFIG_INSTALL_PATH = /etc/wireguard/$(CONFIG_NAME)

# Installation directory for systemd service
SYSTEMD_DIR = /etc/systemd/system

# Copy the script to /usr/local/bin
install-script:
	@echo "Copying the script to /usr/local/bin ..."
	sudo cp $(SCRIPT_PATH) $(INSTALL_PATH)
	sudo chmod +x $(INSTALL_PATH)
	@echo "Script installed to $(INSTALL_PATH)"

# Install the configuration file
install-config:
	@echo "Installing configuration file to $(CONFIG_INSTALL_PATH) ..."
	sudo mkdir -p /etc/wireguard
	@if [ -f $(CONFIG_INSTALL_PATH) ]; then \
		echo "Config file already exists at $(CONFIG_INSTALL_PATH), skipping..."; \
	else \
		sudo cp $(CONFIG_PATH) $(CONFIG_INSTALL_PATH); \
		echo "Config file installed to $(CONFIG_INSTALL_PATH)"; \
		echo "Please edit $(CONFIG_INSTALL_PATH) to set your SERVER_IP and WG_INTERFACE"; \
	fi

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
	sudo rm -f $(CONFIG_INSTALL_PATH)
	@echo "Cleaned up."

# Full installation (script + config + systemd)
install: install-script install-config deploy-systemd
	@echo "Installation complete!"
	@echo ""
	@echo "IMPORTANT: Edit $(CONFIG_INSTALL_PATH) to configure your SERVER_IP and WG_INTERFACE"
	@echo "Then restart the service with: sudo systemctl restart $(SYSTEMD_SERVICE_NAME)"

# Uninstall (script + systemd)
uninstall: clean
	@echo "Uninstallation complete!"
