
#include "core/Version.h"

/*!
 * This file is automatically processed by cmake if the version or commit id changes.
 * Available variables:
 * - BASE_VERSION: The contents of the VERSION file.
 * - GIT_COMMIT: The current git commit. This variable is not defined if there is no .git directory.
 * - GIT_COMMIT_PREFIX_i: The first i characters of the git commit (i=0..39).
 * For the exact syntax see the documentation of the configure_file() cmake command.
 */

#cmakedefine GIT_COMMIT

#ifdef GIT_COMMIT
const std::string version = "${BASE_VERSION} + ${GIT_COMMIT_PREFIX_5}";
#else
const std::string version = "${BASE_VERSION}";
#endif
