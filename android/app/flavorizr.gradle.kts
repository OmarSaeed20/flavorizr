import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("dev") {
            dimension = "flavor-type"
            applicationId = "com.example.flavorizr.dev"
            resValue(type = "string", name = "app_name", value = "Flavorizr Dev")
        }
        create("staging") {
            dimension = "flavor-type"
            applicationId = "com.example.flavorizr.staging"
            resValue(type = "string", name = "app_name", value = "Flavorizr Staging")
        }
        create("prod") {
            dimension = "flavor-type"
            applicationId = "com.example.flavorizr"
            resValue(type = "string", name = "app_name", value = "Flavorizr")
        }
    }
}