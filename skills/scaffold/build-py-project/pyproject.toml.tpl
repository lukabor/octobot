[project]
name = "<project-name>"
version = "0.1.0"
description = "<description>"
readme = "README.md"
requires-python = ">=3.11"
license = { text = "<license>" }
authors = [{ name = "<author-name>", email = "<author-email>" }]

dependencies = []

[dependency-groups]
dev = [
    "ruff>=0.9",
    "ty>=0.0.1",
    "pytest>=8.0",
    "pytest-cov>=5.0",
]

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.hatch.build.targets.wheel]
packages = ["src/<package_name>"]

[tool.ruff]
src = ["src"]
line-length = 90
target-version = "py311"
exclude = [".git", "__pycache__", "dist", ".venv"]

[tool.ruff.lint]
select = ["E", "W", "F", "I", "N", "UP", "B", "SIM", "PTH"]
ignore = ["E501"]

[tool.ruff.lint.isort]
known-first-party = ["<package_name>"]

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
addopts = ["-ra", "--strict-markers", "-q", "--cov=<package_name>", "--cov-report=term-missing"]
markers = [
    "slow: marks tests as slow",
    "integration: marks tests as integration tests",
]

[tool.coverage.run]
source = ["<package_name>"]
branch = true
omit = ["tests/*"]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "raise NotImplementedError",
    "if TYPE_CHECKING:",
]
