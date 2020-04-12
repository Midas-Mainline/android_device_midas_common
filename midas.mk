#
# Copyright 2020 Joonas Kylmälä
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

PRODUCT_PACKAGES += \
    android.hardware.memtrack@1.0-impl.i9305 \
    android.hardware.memtrack@1.0-service.i9305

# Graphics
PRODUCT_PACKAGES += \
    gralloc.gbm \
    hwcomposer.drm \
    libGLES_mesa \
    hwcomposer.ranchu \
    libEGL_swiftshader \
    libGLESv2_swiftshader \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service \
