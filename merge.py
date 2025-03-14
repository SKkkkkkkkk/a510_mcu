#!/usr/bin/env python3
import os
import argparse
import sys

def merge_binary_files(bootloader_path, app_path, output_path, app_offset=0x4000, padding_byte=0xFF, verbose=False):
    """
    Merge bootloader and app binary files with proper offset alignment.
    
    Args:
        bootloader_path: Path to the bootloader binary file
        app_path: Path to the application binary file
        output_path: Path for the output merged file
        app_offset: Memory offset for the app binary (default: 0x4000)
        padding_byte: Byte value used for padding (default: 0xFF)
        verbose: Enable verbose output (default: False)
    """
    try:
        # Check if input files exist
        if not os.path.isfile(bootloader_path):
            raise FileNotFoundError(f"Bootloader file not found: {bootloader_path}")
        if not os.path.isfile(app_path):
            raise FileNotFoundError(f"App file not found: {app_path}")
        
        # Check bootloader size
        bootloader_size = os.path.getsize(bootloader_path)
        if bootloader_size > app_offset:
            raise ValueError(f"Bootloader size ({bootloader_size} bytes) exceeds app offset (0x{app_offset:X})")
        
        if verbose:
            print(f"Bootloader size: {bootloader_size} bytes")
            print(f"App offset: 0x{app_offset:X}")
        
        # Read bootloader data
        with open(bootloader_path, 'rb') as f:
            bootloader_data = f.read()
        
        # Read app data
        with open(app_path, 'rb') as f:
            app_data = f.read()
        
        if verbose:
            print(f"App size: {len(app_data)} bytes")
        
        # Create output directory if it doesn't exist
        output_dir = os.path.dirname(output_path)
        if output_dir and not os.path.exists(output_dir):
            os.makedirs(output_dir)
        
        # Write merged binary
        with open(output_path, 'wb') as f:
            # Write bootloader data
            f.write(bootloader_data)
            
            # Calculate and write padding
            padding_size = app_offset - bootloader_size
            if padding_size > 0:
                if verbose:
                    print(f"Adding {padding_size} bytes of padding (0x{padding_byte:02X})")
                f.write(bytes([padding_byte]) * padding_size)
            
            # Write app data
            f.write(app_data)
        
        total_size = bootloader_size + padding_size + len(app_data)
        print(f"Successfully created {output_path} ({total_size} bytes)")
        return True
        
    except Exception as e:
        print(f"Error: {str(e)}", file=sys.stderr)
        return False

def main():
    parser = argparse.ArgumentParser(description='Merge bootloader and app binary files for flash')
    parser.add_argument('bootloader', help='Path to bootloader.bin')
    parser.add_argument('app', help='Path to app.bin')
    parser.add_argument('output', help='Path to output flash.bin')
    parser.add_argument('--offset', type=lambda x: int(x, 0), default=0x4000,
                        help='App offset in bytes (default: 0x4000)')
    parser.add_argument('--padding', type=lambda x: int(x, 0), default=0xFF,
                        help='Padding byte value (default: 0xFF)')
    parser.add_argument('-v', '--verbose', action='store_true',
                        help='Enable verbose output')
    
    args = parser.parse_args()
    
    success = merge_binary_files(
        args.bootloader, 
        args.app, 
        args.output, 
        app_offset=args.offset,
        padding_byte=args.padding,
        verbose=args.verbose
    )
    
    sys.exit(0 if success else 1)

if __name__ == '__main__':
    main()