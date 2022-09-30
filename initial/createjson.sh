# Run initial/createjson.sh in ota folder

maintainer='' # rokusenpai
devicename='' # Redmi Note 7 Pro
oem='' # Xiaomi
zip='' # ProtonPlus-13.0-Stable-violet-OFFICIAL-20220930-155814.zip
version=`echo $zip | cut -d'-' -f2`-`echo $zip | cut -d'-' -f3`
device=`echo $zip | cut -d'-' -f4`
build_date=`echo $zip | cut -d'-' -f6`


# don't edit
script_path=${PWD}/..
zip_dir=$script_path/out/target/product/$device/$zip
buildprop=$script_path/out/target/product/$device/system/build.prop

if [ -f $script_path/ota/$device.json ]; then
  rm $script_path/ota/$device.json
fi

linenr=`grep -n "ro.system.build.date.utc" $buildprop | cut -d':' -f1`
timestamp=`sed -n $linenr'p' < $buildprop | cut -d'=' -f2`
md5=`md5sum $zip_dir | cut -d' ' -f1`
sha256=`sha256sum $zip_dir | cut -d' ' -f1`
size=`stat -c "%s" $zip_dir`
echo "done."
echo '{
  "response": [
    {
        "codename": "'$device'",
        "devicename": "'$devicename'",
        "maintainer": "'$maintainer'",
        "oem": "'$oem'",
        "filename": "'$zip'",
        "download": "https://github.com/protonplus-org/ota/releases/download/'$version-$device-$build_date'/'$zip'",
        "datetime": '$timestamp',
        "md5": "'$md5'",
        "sha256": "'$sha256'",
        "size": '$size',
        "version": "'$version'"
    }
  ]
}' >> $script_path/ota/$device.json
