import re
from argparse import ArgumentParser
from glob import glob
from os import system
from pathlib import Path
from typing import List, Optional, Union


def read_stripped(path: Union[str, Path]) -> List[str]:
    return [line.rstrip() for line in open(path, "r").readlines()]


if __name__ == "__main__":

    parser = ArgumentParser()
    parser.add_argument(
        "recipe", type=str, help="Recipe file to build Dockerfile from."
    )
    parser.add_argument(
        "--tag", "-t", type=str, help="Build docker image and apply this tag."
    )
    parser.add_argument(
        "--start", "-s", action="store_true", help="Start docker container."
    )
    parser.add_argument(
        "--push", "-p", action="store_true", help="Push image to Docker Hub."
    )

    args = parser.parse_args()
    tag: Optional[str] = args.tag
    start: bool = args.start
    push: bool = args.push

    cwd = Path(__file__).parent.resolve()
    input_path: Path = Path(args.recipe)
    output_path: Path = Path(cwd) / f"output/{input_path.stem}.Dockerfile"

    components_folder = str(cwd / "components")
    components = {
        re.sub(
            r".Dockerfile$", "", re.sub(r"^{}/".format(components_folder), "", item)
        ): item
        for item in glob(f"{components_folder}/**/*.Dockerfile", recursive=True)
    }

    input_lines: List[str] = read_stripped(input_path)
    output_lines: List[str] = []
    for input_line in input_lines:
        if input_line.startswith("IMPORT "):
            component_name = input_line.replace("IMPORT ", "").strip()

            if component_name not in components:
                raise FileNotFoundError(
                    f"{component_name}.Dockerfile is not found in directory {Path('components')}"
                )
            else:

                imported_lines = read_stripped(components[component_name])
                output_lines.append(f"\n# Component: {component_name}")
                output_lines.extend(imported_lines)
        else:
            output_lines.append(input_line)

    open(output_path, "w").write("\n".join(output_lines))

    if tag is not None:
        code = system(f"docker build -t {tag} -f {output_path} {cwd}")

        if code == 0:

            if push:
                system(f"docker push {tag}")

            if start:
                system(f"docker run -it {tag}")

        else:

            exit(code)
