A simple docker container to run g2p harvesters.
See (g2p-aggregator)[https://github.com/ohsu-comp-bio/g2p-aggregator]

## Build

```
$docker build -t g2p-transform .
```

## Container documentation
```
$ docker inspect g2p-transform     | jq -r '.[0].Config.Labels'
{
  "env.HARVESTERS": "A csv environmental variable. default cgi_biomarkers,jax,civic,oncokb,pmkb,molecularmatch,sage,jax_trials,brca",
  "maintainer": "walsbr@ohsu.edu",
  "org.label-schema.description": "Harvest genotype and phenotype data.",
  "org.label-schema.docker.cmd": "docker run --rm -it -v /tmp/g2p:/output -v ~/.synapseCache/.session:/root/.synapseCache/.session  -v ~/g2p-aggregator/harvester/cgi_biomarkers_per_variant.tsv:/g2p-aggregator/harvester/cgi_biomarkers_per_variant.tsv -v ~/g2p-aggregator/harvester/cosmic_lookup_table.tsv:/g2p-aggregator/harvester/cosmic_lookup_table.tsv  -v ~/g2p-aggregator/harvester/harvester.sqlite:/g2p-aggregator/harvester/harvester.sqlite -v ~/g2p-aggregator/harvester/oncokb_all_actionable_variants_20170822.tsv:/g2p-aggregator/harvester/oncokb_all_actionable_variants.tsv g2p-transform",
  "org.label-schema.name": "g2p",
  "org.label-schema.usage": "https://github.com/biostream/g2p-transform/blob/master/README.md",
  "volume.cgi_biomarkers_per_variant": "-v ~/g2p-aggregator/harvester/cgi_biomarkers_per_variant.tsv:/g2p-aggregator/harvester/cgi_biomarkers_per_variant.tsv",
  "volume.cosmic_lookup_table": "-v ~/g2p-aggregator/harvester/cosmic_lookup_table.tsv:/g2p-aggregator/harvester/cosmic_lookup_table.tsv",
  "volume.harvester_cache": "-v ~/g2p-aggregator/harvester/harvester.sqlite:/g2p-aggregator/harvester/harvester.sqlite",
  "volume.oncokb_all_actionable_variants": "-v ~/g2p-aggregator/harvester/oncokb_all_actionable_variants_20170822.tsv:/g2p-aggregator/harvester/oncokb_all_actionable_variants.tsv",
  "volume.output": "/output - harvester will create [harvester_name].json in this dir. Map to host system.",
  "volume.synapseCache": "-v ~/.synapseCache/.session:/root/.synapseCache/.session"
}
```


### inputs

* files
  * see https://github.com/biostream/cosmic-extract
* cache  
  * /g2p-aggregator/harvester/harvester.sqlite

* Credentials
  * -v ~/.synapseCache/.session:/root/.synapseCache/.session
  * -e "MOLECULAR_MATCH_API_KEY=XXXXXXXX"   

### outputs

* `/output/[source-name].json`
* upload to swift

```
$ swift upload --object-name g2p etl-development /tmp/g2p
```
