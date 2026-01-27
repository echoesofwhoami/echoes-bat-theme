#!/usr/bin/env python3
"""
Sample Python file to demonstrate the Echoes theme for bat.
This file showcases various syntax elements and their coloring.
"""

import os
import sys
from typing import List, Dict, Optional

# Constants
VERSION = "1.0.0"
MAX_ITEMS = 100
DEBUG_MODE = True

class DataProcessor:
    """A sample class to demonstrate syntax highlighting."""
    
    def __init__(self, name: str):
        self.name = name
        self.items: List[str] = []
        self.metadata: Dict[str, any] = {}
    
    def process_data(self, data: List[str]) -> Optional[str]:
        """
        Process a list of data items.
        
        Args:
            data: List of strings to process
            
        Returns:
            Processed result or None if failed
        """
        if not data:
            return None
            
        result = ""
        for i, item in enumerate(data):
            if i > 0:
                result += ", "
            result += item.upper()
            
        return result
    
    def validate_input(self, value: str) -> bool:
        """Validate input string."""
        return len(value) > 0 and not value.isspace()

def main():
    """Main function demonstrating various Python features."""
    processor = DataProcessor("test")
    
    # Sample data
    sample_items = ["apple", "banana", "cherry", "date"]
    
    # Process data
    result = processor.process_data(sample_items)
    
    if result:
        print(f"Processed: {result}")
        print(f"Length: {len(result)}")
    else:
        print("Processing failed!")
    
    # Boolean operations
    is_valid = processor.validate_input("test")
    is_empty = not sample_items
    
    # Numbers and arithmetic
    count = len(sample_items)
    doubled = count * 2
    remainder = count % 2
    
    print(f"Count: {count}, Doubled: {doubled}, Remainder: {remainder}")
    
    # Conditional logic
    if is_valid and count > 0:
        print("All good!")
    elif is_empty:
        print("No data to process")
    else:
        print("Something went wrong")

if __name__ == "__main__":
    main()
