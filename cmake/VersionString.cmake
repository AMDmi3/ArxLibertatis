
# Create a rule to generate a version string at compile time.
#
# An optional fifth argument can be used to add additional cmake defines.
#
# SRC is processed using the configure_file() cmake command
# at build to produce DST with the following variable available:
#
# - BASE_VERSION: The contents of the file specified by VERSION_FILE
# - BASE_VERSION_COUNT: Number of lines in the VERSION file
# - BASE_VERSION_i: The i-th line of the VERSION file
# - BASE_NAME_i: Everything except the last component of the i-th line of the VERSION file
# - BASE_NUMBER_i: The last component of the i-th line of the VERSION file
# - GIT_COMMIT: The current git commit. (not defined if there is no GIT_DIR directory)
# - GIT_COMMIT_PREFIX_i: The first i characters of GIT_COMMIT (i=0..39)
# For the exact syntax of SRC see the documentation of the configure_file() cmake command.
# The version file is regenerated whenever VERSION_FILE or the current commit changes.
function(version_file SRC DST VERSION_FILE GIT_DIR)
	
	get_filename_component(abs_src "${SRC}" ABSOLUTE)
	get_filename_component(abs_dst "${DST}" ABSOLUTE)
	get_filename_component(abs_version_file "${VERSION_FILE}" ABSOLUTE)
	get_filename_component(abs_git_dir "${GIT_DIR}" ABSOLUTE)
	
	set(defines)
	if(${ARGC} GREATER 4)
		set(defines ${ARGV4})
	endif()
	
	set(dependencies "${abs_version_file}" "${CMAKE_MODULE_PATH}/VersionScript.cmake")
	
	if(EXISTS "${abs_git_dir}/HEAD")
		list(APPEND dependencies "${abs_git_dir}/HEAD")
	endif()
	
	if(EXISTS "${abs_git_dir}/logs/HEAD")
		list(APPEND dependencies "${abs_git_dir}/logs/HEAD")
	endif()
	
	add_custom_command(
		OUTPUT
			"${abs_dst}"
		COMMAND
			${CMAKE_COMMAND}
			"-DINPUT=${abs_src}"
			"-DOUTPUT=${abs_dst}"
			"-DVERSION_FILE=${abs_version_file}"
			"-DGIT_DIR=${abs_git_dir}"
			${defines}
			-P "${CMAKE_MODULE_PATH}/VersionScript.cmake"
		MAIN_DEPENDENCY
			"${abs_src}"
		DEPENDS
			${dependencies}
		COMMENT ""
		VERBATIM
	)
	
endfunction(version_file)
