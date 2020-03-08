CONDA_BUILD ?= conda-build --use-local
ALL_PKGS    :=


define CONDA_TARGET
ALL_PKGS += $(1)

$(1): .done/$(1)

.done/$(1): $(wildcard $(1)/*) $(2)
	mkdir -p .done
	$(CONDA_BUILD) $(1) && touch .done/$(1)
endef


$(eval $(call CONDA_TARGET,boost,zlib bzip2 xz zstd icu))

$(eval $(call CONDA_TARGET,zlib,))

$(eval $(call CONDA_TARGET,bzip2,))

$(eval $(call CONDA_TARGET,zstd,))

$(eval $(call CONDA_TARGET,xz,))

$(eval $(call CONDA_TARGET,icu,))

$(eval $(call CONDA_TARGET,gmp,))

$(eval $(call CONDA_TARGET,gtest,))

$(eval $(call CONDA_TARGET,yaml-cpp,))

$(eval $(call CONDA_TARGET,openssl,))


.PHONY: clean $(ALL_PKGS)

all: $(ALL_PKGS)

clean:
	rm -rf .done

print-pkgs:
	@echo $(ALL_PKGS)
