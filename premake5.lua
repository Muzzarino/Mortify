workspace "Mortify"
    architecture "x64"
    startproject "Sandbox"

    configurations { 
		"Debug",
		"Release",
		"Dist" 
	}

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

-- Include directories relative to root folder (solution dir)
IncludeDir = {}
IncludeDir["GLFW"] = "Mortify/vendor/GLFW/include"
IncludeDir["Glad"] = "Mortify/vendor/Glad/include"
IncludeDir["ImGui"] = "Mortify/vendor/ImGui"
IncludeDir["glm"] = "Mortify/vendor/glm"

include "Mortify/vendor/GLFW"
include "Mortify/vendor/Glad"
include "Mortify/vendor/ImGui"

project "Mortify"
    location "Mortify"
    kind "StaticLib"
    language "C++"
    cppdialect "C++17"
    staticruntime "on"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	pchheader "mtpch.h"
	pchsource "Mortify/src/mtpch.cpp"

    files {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp",
		"%{prj.name}/vendor/glm/glm/**.hpp",
		"%{prj.name}/vendor/glm/glm/**.inl"
    }

    defines {
        "_CRT_SECURE_NO_WARNINGS"
    }

    includedirs {
		"%{prj.name}/src",
        "%{prj.name}/vendor/spdlog/include",
		"%{IncludeDir.GLFW}",
		"%{IncludeDir.Glad}",
		"%{IncludeDir.ImGui}",
		"%{IncludeDir.glm}"
    }

	links {
		"GLFW",
		"Glad",
		"ImGui",
		"opengl32.lib"
	}

    filter "system:windows"
        systemversion "latest"

        defines {
            "MT_PLATFORM_WINDOWS",
            "MT_BUILD_DLL",
			"GLFW_INCLUDE_NONE"
        }

    filter "configurations:Debug"
        defines "MT_DEBUG"
		runtime "Debug"
        symbols "on"

    filter "configurations:Release"
        defines "MT_RELEASE"
		runtime "Release"
        optimize "on"

    filter "configurations:Dist"
        defines "MT_DIST"
		runtime "Release"
        optimize "on"

project "Sandbox"
    location "Sandbox"
    kind "ConsoleApp"
    language "C++"
    cppdialect "C++17"
	staticruntime "on"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

    files {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }

    includedirs {
        "Mortify/src",
        "Mortify/vendor/spdlog/include",
        "Mortify/vendor/ImGui",
        "%{IncludeDir.glm}",
        "%{IncludeDir.Glad}"
    }

	links {
		"Mortify"
	}

    filter "system:windows"
        systemversion "latest"
    
        defines {
            "MT_PLATFORM_WINDOWS",
        }

    filter "configurations:Debug"
        defines "MT_DEBUG"
		runtime "Debug"
        symbols "on"

    filter "configurations:Release"
        defines "MT_RELEASE"
		runtime "Release"
        optimize "on"

    filter "configurations:Dist"
        defines "MT_DIST"
		runtime "Release"
        optimize "on"