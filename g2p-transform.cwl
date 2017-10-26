#!/usr/bin/env cwl-runner

# this should produce a docker run of the form:
# docker run --rm -it \
# -e "MOLECULAR_MATCH_API_KEY=XXXXXXXX" \
# -v /tmp/g2p:/output \
# -v ~/.synapseCache/.session:/root/.synapseCache/.session  \
# -v /tmp/g2p/cgi_biomarkers_per_variant.tsv:/g2p-aggregator/harvester/cgi_biomarkers_per_variant.tsv \
# -v /tmp/g2p/cosmic_lookup_table.tsv:/g2p-aggregator/harvester/cosmic_lookup_table.tsv  \
# -v /tmp/g2p/harvester.sqlite:/g2p-aggregator/harvester/harvester.sqlite \
# -v /tmp/g2p/oncokb_all_actionable_variants_20170822.tsv:/g2p-aggregator/harvester/oncokb_all_actionable_variants.tsv \
# g2p-transform

# note: the volumes & swiftPath attribute is somewhat ad-hoc, there is no official support for openstack swift

cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: cosmic-extract:latest
baseCommand: harvest-all.sh
requirements:
  EnvVarRequirement:
    envDef:
      MOLECULAR_MATCH_API_KEY: XXXXXXXXXX
inputs:
  /root/.synapseCache/.session:
    type: File
  /g2p-aggregator/harvester/cgi_biomarkers_per_variant.tsv:
    type: File
  /g2p-aggregator/harvester/cosmic_lookup_table.tsv:
    type: File

outputs:
  output:
    type: Directory
volumes:
 - name: output
   hostPath: /tmp/g2p
   swiftPath: $OS_STORAGE_URL/etl-development/g2p
 - name: /root/.synapseCache/.session
   hostPath: ~/.synapseCache/.session
 - name: /g2p-aggregator/harvester/cgi_biomarkers_per_variant.tsv
   hostPath: /tmp/cosmic/cgi_biomarkers_per_variant.tsv
   swiftPath: $OS_STORAGE_URL/etl-development/cosmic/cgi_biomarkers_per_variant.tsv
 - name: /g2p-aggregator/harvester/harvester.sqlite
   hostPath: /tmp/g2p/harvester.sqlite
   swiftPath: $OS_STORAGE_URL/etl-development/g2p/harvester.sqlite
 - name: /g2p-aggregator/harvester/oncokb_all_actionable_variants_20170822.tsv
   hostPath: /tmp/cosmic/oncokb_all_actionable_variants_20170822.tsv
   swiftPath: $OS_STORAGE_URL/etl-development/cosmic/oncokb_all_actionable_variants_20170822.tsv
