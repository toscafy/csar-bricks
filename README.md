# csar-bricks

[![Build Status](https://travis-ci.org/toscafy/csar-bricks.svg?branch=master)](https://travis-ci.org/toscafy/csar-bricks)
[![Build Status](https://snap-ci.com/toscafy/csar-bricks/branch/master/build_image)](https://snap-ci.com/toscafy/csar-bricks/branch/master)

This repository contains bricks and building blocks to generate TOSCA CSARs using **[toscafy](https://github.com/toscafy/toscafy)**.
CSARs are built through a [Snap pipeline](https://snap-ci.com/toscafy/csar-bricks) and a [Travis pipeline](https://travis-ci.org/toscafy/csar-bricks).

Currently, the Snap pipeline produces node types and pushes them into the [Winery](http://winery.opentosca.org/winery/nodetypes).
The Travis pipeline creates [GitHub releases](https://github.com/toscafy/csar-bricks/releases), providing CSARs as downloadable artifacts.
