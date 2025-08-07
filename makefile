# Jekyll Build and Deploy Makefile
# 
# Usage:
#   make build    - Build Jekyll site only
#   make deploy   - Full build and deploy workflow
#   make clean    - Clean the _site directory
# 	make sync 	  - Builds and syncs without committing

# Configuration
SITE_DIR = _site/
DEPLOY_DIR = ../jerielizabeth.github.io/
CURRENT_BRANCH = main
DEPLOY_BRANCH = gh-pages

# Colors for output
RED = \033[0;31m
GREEN = \033[0;32m
YELLOW = \033[1;33m
NC = \033[0m # No Color

.PHONY: build deploy clean check-deploy-dir commit-current commit-deploy help

# Default target
all: deploy

# Build Jekyll site
build:
	@echo "$(YELLOW)Building Jekyll site...$(NC)"
	bundle exec jekyll build
	@echo "$(GREEN)Jekyll build complete!$(NC)"

# Check if deployment directory exists
check-deploy-dir:
	@if [ ! -d "$(DEPLOY_DIR)" ]; then \
		echo "$(RED)Error: Deployment directory $(DEPLOY_DIR) does not exist!$(NC)"; \
		echo "$(YELLOW)Please ensure the jerielizabeth.github.io repository is cloned at the correct location.$(NC)"; \
		exit 1; \
	fi

# Sync built site to deployment directory
sync: build check-deploy-dir
	@echo "$(YELLOW)Syncing _site/ to $(DEPLOY_DIR)...$(NC)"
	rsync -av --delete $(SITE_DIR) $(DEPLOY_DIR)
	@echo "$(GREEN)Sync complete!$(NC)"

# Commit and push changes in current directory
commit-current:
	@echo "$(YELLOW)Committing changes in current directory...$(NC)"
	@if [ -n "$$(git status --porcelain)" ]; then \
		git add -A; \
		git commit -m "Update site content - $$(date '+%Y-%m-%d %H:%M:%S')"; \
		git push origin $(CURRENT_BRANCH); \
		echo "$(GREEN)Current directory changes committed and pushed!$(NC)"; \
	else \
		echo "$(YELLOW)No changes to commit in current directory.$(NC)"; \
	fi

# Commit and push changes in deployment directory
commit-deploy: check-deploy-dir
	@echo "$(YELLOW)Committing changes in deployment directory...$(NC)"
	@cd $(DEPLOY_DIR) && \
	if [ -n "$$(git status --porcelain)" ]; then \
		git add -A; \
		git commit -m "Deploy site update - $$(date '+%Y-%m-%d %H:%M:%S')"; \
		git push origin $(DEPLOY_BRANCH); \
		echo "$(GREEN)Deployment directory changes committed and pushed to $(DEPLOY_BRANCH)!$(NC)"; \
	else \
		echo "$(YELLOW)No changes to commit in deployment directory.$(NC)"; \
	fi

# Full deployment workflow
deploy: sync commit-current commit-deploy
	@echo "$(GREEN)========================================$(NC)"
	@echo "$(GREEN)Deployment complete!$(NC)"
	@echo "$(GREEN)========================================$(NC)"

# Clean the _site directory
clean:
	@echo "$(YELLOW)Cleaning _site directory...$(NC)"
	rm -rf $(SITE_DIR)
	@echo "$(GREEN)Clean complete!$(NC)"

# Rebuild everything from scratch
rebuild: clean build
	@echo "$(GREEN)Rebuild complete!$(NC)"

# Show help
help:
	@echo "$(GREEN)Jekyll Build and Deploy Makefile$(NC)"
	@echo ""
	@echo "Available targets:"
	@echo "  $(YELLOW)build$(NC)         - Build Jekyll site only"
	@echo "  $(YELLOW)sync$(NC)          - Build and sync to deployment directory"
	@echo "  $(YELLOW)deploy$(NC)        - Full build and deploy workflow (default)"
	@echo "  $(YELLOW)commit-current$(NC) - Commit and push current directory changes"
	@echo "  $(YELLOW)commit-deploy$(NC) - Commit and push deployment directory changes"
	@echo "  $(YELLOW)clean$(NC)         - Clean the _site directory"
	@echo "  $(YELLOW)rebuild$(NC)       - Clean and rebuild from scratch"
	@echo "  $(YELLOW)help$(NC)          - Show this help message"
	@echo ""
	@echo "Configuration:"
	@echo "  Site directory: $(SITE_DIR)"
	@echo "  Deploy directory: $(DEPLOY_DIR)"
	@echo "  Current branch: $(CURRENT_BRANCH)"
	@echo "  Deploy branch: $(DEPLOY_BRANCH)"