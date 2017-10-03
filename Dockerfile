FROM python:2.7



# get source & build it
RUN git clone https://github.com/ohsu-comp-bio/g2p-aggregator.git
WORKDIR /g2p-aggregator
RUN git checkout new-harvesters

# install dependencies
WORKDIR /g2p-aggregator/harvester
RUN pip install -r requirements.txt

# output should appear here
VOLUME ["/output"]

# run it
COPY ./harvest-all.sh /g2p-aggregator/harvester
ENTRYPOINT ["./harvest-all.sh"]


# documentation
LABEL maintainer="walsbr@ohsu.edu"
LABEL org.label-schema.name="g2p"
LABEL org.label-schema.description="Harvest genotype and phenotype data."
LABEL org.label-schema.usage="https://github.com/biostream/g2p-transform/blob/master/README.md"
LABEL org.label-schema.docker.cmd="docker run --rm -it \
-e "MOLECULAR_MATCH_API_KEY=XXXXXXXX" \
-v /tmp/g2p:/output \
-v ~/.synapseCache/.session:/root/.synapseCache/.session  \
-v ~/g2p-aggregator/harvester/cgi_biomarkers_per_variant.tsv:/g2p-aggregator/harvester/cgi_biomarkers_per_variant.tsv \
-v ~/g2p-aggregator/harvester/cosmic_lookup_table.tsv:/g2p-aggregator/harvester/cosmic_lookup_table.tsv  \
-v ~/g2p-aggregator/harvester/harvester.sqlite:/g2p-aggregator/harvester/harvester.sqlite \
-v ~/g2p-aggregator/harvester/oncokb_all_actionable_variants_20170822.tsv:/g2p-aggregator/harvester/oncokb_all_actionable_variants.tsv \
g2p-transform"

LABEL env.HARVESTERS="A csv environmental variable. default cgi_biomarkers,jax,civic,oncokb,pmkb,molecularmatch,sage,jax_trials,brca"
LABEL volume.output="/output - harvester will create [harvester_name].json in this dir. Map to host system."
LABEL volume.synapseCache="-v ~/.synapseCache/.session:/root/.synapseCache/.session"
LABEL volume.cgi_biomarkers_per_variant="-v ~/g2p-aggregator/harvester/cgi_biomarkers_per_variant.tsv:/g2p-aggregator/harvester/cgi_biomarkers_per_variant.tsv"
LABEL volume.cosmic_lookup_table="-v ~/g2p-aggregator/harvester/cosmic_lookup_table.tsv:/g2p-aggregator/harvester/cosmic_lookup_table.tsv"
LABEL volume.harvester_cache="-v ~/g2p-aggregator/harvester/harvester.sqlite:/g2p-aggregator/harvester/harvester.sqlite"
LABEL volume.oncokb_all_actionable_variants="-v ~/g2p-aggregator/harvester/oncokb_all_actionable_variants_20170822.tsv:/g2p-aggregator/harvester/oncokb_all_actionable_variants.tsv"
