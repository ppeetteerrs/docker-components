# Docker Components
> Helper Scripts and Files to Include Nice Features in Any Dockerfile

## Usage
1. Write a recipe in `/recipes`. It is like a normal `Dockerfile`.
2. Use `IMPORT <component_name>` in your recipe to import a component. Resource files will be copied from `resources/` to `/resources/` in the image.
3. Run `python build.py` to output a `Dockerfile` in the `output/` folder. Other options include:
   - `-t tag`: Build the docker image with tag `tag`.
   - `-p`: Push docker image to Docker Hub after the build.
   - `-s`: Start the docker container after the build.