# before uploading createjson & write changelogs
# before using this make sure to login using gh

zip='ProtonPlus-13.02-Stable-beryllium-OFFICIAL-20221129-171605.zip' # ProtonPlus-13.0-Stable-violet-OFFICIAL-20220930-155814.zip
ab='0' # if device is a/b or a only for a/b=1 a only=0
version=`echo $zip | cut -d'-' -f2`-`echo $zip | cut -d'-' -f3`
device=`echo $zip | cut -d'-' -f4`
build_date=`echo $zip | cut -d'-' -f6`

git add devices/$device/ && git commit -m "ota: $version-$device-$build_date "

git push origin tm 

script_path=${PWD}/..
zip_dir=$script_path/out/target/product/$device/$zip
rec_dir=$script_path/out/target/product/$device/rec*.img
boot_dir=$script_path/out/target/product/$device/bo*.img
vendor_dir=$script_path/out/target/product/$device/vendor_bo*.img

gh release create $version-$device-$build_date $zip_dir
if [ $ab == 1 ]; then
    gh release upload $version-$device-$build_date $boot_dir
    echo "boot uploaded"
    gh release upload $version-$device-$build_date $vendor_dir
    echo "vendorboot uploaded"
else 
    gh release upload $version-$device-$build_date $rec_dir
    echo "recovery uploaded"
fi
