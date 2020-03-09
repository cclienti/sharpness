SHARPNESS_VERSION  ?= sharpness-1
CONDA_REPO         ?= /opt/conda-packages/$(SHARPNESS_VERSION)
CONDA_BUILD        ?= conda-build
CONDA_BUILD_FLAGS  ?= --use-local
CONDA_INDEX        ?= conda-index
CONDA_INDEX_FLAGS  ?= -n $(SHARPNESS_VERSION) --verbose --no-progress
SHELL              ?= /bin/bash

ALL_PKGS :=

define CONDA_TARGET
ALL_PKGS += $(1)

$(1): .done/$(1)

.done/$(1): $(wildcard $(1)/*) $(addprefix .done/,$(2))
	$(CONDA_BUILD) $(CONDA_FLAGS) $(1)
	_helpers/move-package $(CONDA_BUILD) $(CONDA_REPO) $(1)
	$(CONDA_INDEX) $(CONDA_INDEX_FLAGS) $(CONDA_REPO)
	mkdir -p .done && touch .done/$(1)
endef


$(eval $(call CONDA_TARGET,boost,zlib bzip2 xz zstd icu))

$(eval $(call CONDA_TARGET,zlib,))

$(eval $(call CONDA_TARGET,bzip2,))

$(eval $(call CONDA_TARGET,zstd,))

$(eval $(call CONDA_TARGET,xz,))

$(eval $(call CONDA_TARGET,icu,))

$(eval $(call CONDA_TARGET,gmp,))

$(eval $(call CONDA_TARGET,gtest,))

$(eval $(call CONDA_TARGET,yaml-cpp,gtest))

$(eval $(call CONDA_TARGET,openssl,))


.PHONY: clean $(ALL_PKGS)

all: $(ALL_PKGS)

clean:
	conda build purge
	rm -rf .done

print-pkgs:
	@echo $(ALL_PKGS)
