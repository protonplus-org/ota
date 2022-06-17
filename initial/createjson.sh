#!/bin/bash
# make executable (chmod +x ota/initial/createjson.sh) and run it (./ota/initial/createjson.sh)

#modify values below
#leave blank if not used
codename=""
devicename="name of device" #ex: OnePlus 7 Pro
maintainer="Name " #ex: Lup Gabriel (gwolfu)
oem="OEM" #ex: OnePlus
zip="protonplus zip" #ex: ProtonPlus-<android version>-<date>-<device codename>-v<proton version>.zip


#don't modify from here
script_path="${PWD}"
zip_name=$script_path/out/target/product/$device/$zip
buildprop=$script_path/out/target/product/$device/system/build.prop

if [ -f $script_path/ota/$device.json ]; then
  rm $script_path/ota/$device.json
fi

linenr=`grep -n "ro.system.build.date.utc" $buildprop | cut -d':' -f1`
timestamp=`sed -n $linenr'p' < $buildprop | cut -d'=' -f2`
zip_only=`basename "$zip_name"`
md5=`md5sum "$zip_name" | cut -d' ' -f1`
sha256=`sha256sum "$zip_name" | cut -d' ' -f1`
size=`stat -c "%s" "$zip_name"`
version=`echo "$zip_only" | cut -d'-' -f2`
echo "done."
echo '{
  "response": [
    {
        "codename": "'$codename'",
        "devicename": "'$devicename'",
        "maintainer": "'$maintainer'",
        "oem": "'$oem'",
        "filename": "'$zip_only'",
        "download": "https://sourceforge.net/projects/protonplus/files/SnowCone/'$device'/'$zip_only'/download",
        "datetime": '$timestamp',
        "md5": "'$md5'",
        "sha256": "'$sha256'",
        "size": '$size',
        "version": "'$version'"
    }
  ]
}' >> ota/$device.json
