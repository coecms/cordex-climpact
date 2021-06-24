#!/g/data/hh5/public/apps/nci_scripts/python-analysis3
# Copyright 2021 Scott Wales
# author: Scott Wales <scott.wales@unimelb.edu.au>
#
# Licensed under the Apache License, Version 2.0 (the "License");
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

import intake
import sys

var = sys.argv[1]
output = sys.argv[2]

cat = intake.cat.nci.esgf.cordex

print(cat[var].df.path.values)

ds = cat[var].to_dask()

bnds = []

for name, var in ds.coords.items():
    # Remove bounds attributes
    bnds.append(var.attrs.pop('bounds',None))

    # No fill value on coords
    var.encoding['_FillValue'] = None

# Delete bounds
for v in bnds:
    if v is not None:
        del ds[v]

for name, var in ds.items():
    if '_FillValue' in var.encoding:
        # Ensure missing_value and FillValue match
        var.encoding['missing_value'] = var.encoding['_FillValue']
        
    var.attrs.pop('grid_mapping', None)

    # Change units
    if var.attrs['units'] == 'mm':
        var.attrs['units'] = 'kg m-2 d-1'

if 'crs' in ds:
    del ds['crs']

print(ds)

ds.to_netcdf(output)
