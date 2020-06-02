##################################################################
# Options
##################################################################

# Conda Distribution Path
CONDA_DISTRIB_PATH      ?= $(shell conda info --base)
# Name of the environment to build packages
CONDA_BUILD_ENVIRONMENT ?= build-sharpness
# Conda channel useful to build packages
CONDA_CHANNELS          ?= -c conda-forge


# Conda Destination Repository Base Path
CONDA_DEST_PATH    ?= /opt/conda-packages
# Conda Destination Channel within the Base Path
CONDA_DEST_CHANNEL ?= sharpness-1
# Python verion
CONDA_PYTHON_VERSION ?= 3.7
# Python verion
CONDA_NUMPY_VERSION ?= 1.17

##################################################################
# Local variables
##################################################################

CONDA_DEST_REPO = $(CONDA_DEST_PATH)/$(CONDA_DEST_CHANNEL)

CONDA_BUILD     = conda-build --python $(CONDA_PYTHON_VERSION) \
			      --numpy $(CONDA_NUMPY_VERSION) \
                              $(CONDA_CHANNELS) --use-local
CONDA_VERIFY    = conda-verify
CONDA_INDEX     = conda-index --no-progress -n $(CONDA_DEST_CHANNEL)


##################################################################
# Generic Rule
##################################################################

ALL_PKGS :=

# Macro to define rules
define CONDA_GENERIC_RULES
ALL_PKGS += $(1)

$(1): .done/$(1) .verified/$(1)

.done/$(1): $(wildcard $(1)/*) $(addprefix .done/,$(2))
	set -e; \
	  . $(CONDA_DISTRIB_PATH)/etc/profile.d/conda.sh; \
	  conda activate $(CONDA_BUILD_ENVIRONMENT); \
	  $(CONDA_BUILD) --output-folder $(CONDA_DEST_REPO) $(1)
	mkdir -p .done
	touch .done/$(1)

.name/$(1):
	@set -e; \
	  . $(CONDA_DISTRIB_PATH)/etc/profile.d/conda.sh; \
	  conda activate $(CONDA_BUILD_ENVIRONMENT); \
	  $(CONDA_BUILD) --output-folder $(CONDA_DEST_REPO) --output $(1) 2>/dev/null

.verified/$(1):
	set -e; \
	  . $(CONDA_DISTRIB_PATH)/etc/profile.d/conda.sh; \
	  conda activate $(CONDA_BUILD_ENVIRONMENT); \
	  $(CONDA_VERIFY) `$(MAKE) -s .name/$(1)`
	mkdir -p .verified
	touch .verified/$(1)

endef


##################################################################
# Rules
##################################################################

$(eval $(call CONDA_GENERIC_RULES,boost,zlib bzip2 xz zstd icu))

$(eval $(call CONDA_GENERIC_RULES,zlib,))

$(eval $(call CONDA_GENERIC_RULES,bzip2,))

$(eval $(call CONDA_GENERIC_RULES,zstd,))

$(eval $(call CONDA_GENERIC_RULES,xz,))

$(eval $(call CONDA_GENERIC_RULES,icu,))

$(eval $(call CONDA_GENERIC_RULES,gmp,))

$(eval $(call CONDA_GENERIC_RULES,gtest,))

$(eval $(call CONDA_GENERIC_RULES,yaml-cpp,gtest))

$(eval $(call CONDA_GENERIC_RULES,openssl,))

$(eval $(call CONDA_GENERIC_RULES,iwyu,))


.PHONY: clean $(ALL_PKGS)

env:
	mkdir -p $(CONDA_DEST_REPO)
	set -e; \
	  . $(CONDA_DISTRIB_PATH)/etc/profile.d/conda.sh; \
	  conda create -y -n $(CONDA_BUILD_ENVIRONMENT) \
	      python=$(CONDA_PYTHON_VERSION) \
              numpy=$(CONDA_NUMPY_VERSION) \
              conda-build conda-verify

package: $(addprefix .done/,$(ALL_PKGS))

index:
	set -e; \
	  . $(CONDA_DISTRIB_PATH)/etc/profile.d/conda.sh; \
	  conda activate $(CONDA_BUILD_ENVIRONMENT); $(CONDA_INDEX) $(CONDA_INDEX_FLAGS) $(CONDA_DEST_REPO)

verify: $(addprefix .verified/,$(ALL_PKGS))

clean:
	rm -rf .done .verified
	set -e; \
	  . $(CONDA_DISTRIB_PATH)/etc/profile.d/conda.sh; \
	  conda env remove -y -n $(CONDA_BUILD_ENVIRONMENT)

print-pkgs:
	@echo $(ALL_PKGS)
