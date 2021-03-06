app-debug.apk: android_studio_app/Spiped/app/build/outputs/apk/app-debug.apk
	cp android_studio_app/Spiped/app/build/outputs/apk/app-debug.apk app-debug.apk

android_studio_app/Spiped/app/build/outputs/apk/app-debug.apk: android_studio_app/Spiped/app/src/main/jniLibs/armeabi/libgojni.so android_studio_app/Spiped/app/src/main/jniLibs/armeabi-v7a/libgojni.so android_studio_app/Spiped/app/src/main/java/go/spiped/Spipedmobile.java
	cd android_studio_app/Spiped/ && ./gradlew assembleDebug

android_so_lib/libgojni.so: 
	cd android_so_lib && CC=${NDK_ROOT}/arm-linux-androideabi/bin/gcc CGO_ENABLED=1 GOOS=android GOARCH=arm go build -o libgojni.so -ldflags="-shared"

android_studio_app/Spiped/app/src/main/jniLibs/armeabi/libgojni.so: android_so_lib/main.go go_spiped/go_spiped.go
	mkdir -p android_studio_app/Spiped/app/src/main/jniLibs/armeabi
	cd android_so_lib && CC=${NDK_ROOT}/arm-linux-androideabi/bin/gcc CGO_ENABLED=1 GOOS=android GOARCH=arm GOARM=5 go build -o ../android_studio_app/Spiped/app/src/main/jniLibs/armeabi/libgojni.so -ldflags="-shared"

android_studio_app/Spiped/app/src/main/jniLibs/armeabi-v7a/libgojni.so: android_so_lib/main.go go_spiped/go_spiped.go
	mkdir -p android_studio_app/Spiped/app/src/main/jniLibs/armeabi-v7a
	cd android_so_lib && CC=${NDK_ROOT}/arm-linux-androideabi/bin/gcc CGO_ENABLED=1 GOOS=android GOARCH=arm GOARM=7 go build -o ../android_studio_app/Spiped/app/src/main/jniLibs/armeabi-v7a/libgojni.so -ldflags="-shared"

android_studio_app/Spiped/app/src/main/java/go/spiped/Spipedmobile.java: spipedmobile.go assets/bundle.go
	mkdir -p android_studio_app/Spiped/app/src/main/java/go/spiped
	CGO_ENABLED=0 gobind -lang=java . > android_studio_app/Spiped/app/src/main/java/go/spiped/Spipedmobile.java

go_spiped/go_spiped.go: spipedmobile.go assets/bundle.go
	mkdir -p go_spiped
	CGO_ENABLED=0 gobind -lang=go . > go_spiped/go_spiped.go

assets/bundle.go: webroot/license.html webroot/template.index.html
	cd webroot && gobundle --recursive --compress --uncompress_on_init --retain_uncompressed --bundle="webroot" --package=assets --target=../assets/bundle.go bootstrap-3.3.0 jquery.min.js license.html template.index.html

clean:
	rm -f assets/bundle.go
	rm -f go_spiped/go_spiped.go
	rm -f android_studio_app/Spiped/app/src/main/java/go/spiped/Spipedmobile.java
	rm -f android_studio_app/Spiped/app/src/main/jniLibs/armeabi/libgojni.so
	rm -f android_studio_app/Spiped/app/src/main/jniLibs/armeabi-v7a/libgojni.so
	rm -f android_studio_app/Spiped/app/build/outputs/apk/app-debug.apk
	rm -f app-debug.apk

