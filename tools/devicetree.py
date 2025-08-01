import sys
import fdt

def main(argc, argv):
    try:
        if argc != 3:
            raise Exception(f"Usage: {argv[0]} <input.dtb> <output.dts>")
        dtb_file_path = argv[1]
        dts_file_path = argv[2]
        # Read the binary data from the .dtb file
        with open(dtb_file_path, "rb") as f:
            dtb_data = f.read()
        # Parse the .dtb data
        device_tree = fdt.parse_dtb(dtb_data)
        # Convert the parsed device tree object to .dts format
        dts_content = device_tree.to_dts()
        # Write the .dts content to a file
        with open(dts_file_path, "w") as f:
            f.write(dts_content)
        print(f"Successfully converted '{dtb_file_path}' to '{dts_file_path}'")
        return 0
    except FileNotFoundError:
        print(f"Error: The file '{dtb_file_path}' was not found.")
        return 1
    except Exception as e:
        print(e)
        return 1

if __name__ == '__main__':
    sys.exit(main(len(sys.argv),sys.argv))
