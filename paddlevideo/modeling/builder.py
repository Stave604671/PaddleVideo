# Copyright (c) 2020  PaddlePaddle Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from .registry import BACKBONES, HEADS, LOSSES, RECOGNIZERS, LOCALIZERS, ROI_EXTRACTORS, DETECTORS, BBOX_ASSIGNERS, BBOX_SAMPLERS, BBOX_CODERS
from ..utils import build


def build_backbone(cfg):
    """Build backbone."""
    return build(cfg, BACKBONES)

def build_roi_extractor(cfg):
    """Build roi extractor."""
    return build(cfg, ROI_EXTRACTORS)


def build_assigner(cfg, **default_args):
    """Builder of box assigner."""
    return build(cfg, BBOX_ASSIGNERS)


def build_sampler(cfg, **default_args):
    """Builder of box sampler."""
    return build(cfg, BBOX_SAMPLERS)


def build_head(cfg):
    """Build head."""
    return build(cfg, HEADS)


def build_loss(cfg):
    """Build loss."""
    return build(cfg, LOSSES)


def build_recognizer(cfg):
    """Build recognizer."""
    return build(cfg, RECOGNIZERS, key='framework')


def build_localizer(cfg):
    """Build localizer."""
    return build(cfg, LOCALIZERS, key='framework')

def build_detector(cfg, train_cfg=None, test_cfg=None):
    """Build detector."""
    return build(cfg, DETECTORS, key='framework')


def build_model(cfg):
    cfg_copy = cfg.copy()
    framework_type = cfg_copy.get('framework')
    if framework_type in RECOGNIZERS:
        return build_recognizer(cfg)
    elif framework_type in LOCALIZERS:
        return build_localizer(cfg)
    elif framework_type in DETECTORS:
        return build_detector(cfg)
    else:
        raise NotImplementedError
