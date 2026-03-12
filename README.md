# study-files

A personal repository for organizing and managing study materials.

## Folder Structure

```
study-files/
├── notes/        # Written notes, summaries, and documents (.md, .txt, .pdf, .doc)
├── exercises/    # Code exercises and practice files (.py, .js, .java, .sh, …)
├── resources/    # Images, videos, archives, and other reference assets
├── projects/     # Larger study projects (place each project in its own sub-folder)
└── scripts/      # Utility scripts for managing this repository
```

## Sorting Files Automatically

The `scripts/sort_files.sh` script moves loose files from the **repository root** into the correct folder based on their extension.

```bash
# Sort files that are sitting in the root of the repository
./scripts/sort_files.sh

# Sort files from a custom source directory
./scripts/sort_files.sh /path/to/your/downloads
```

### Extension → Folder mapping

| Extension(s)                              | Destination    |
|-------------------------------------------|----------------|
| `.md` `.txt` `.pdf` `.doc` `.docx`        | `notes/`       |
| `.py` `.js` `.ts` `.java` `.c` `.cpp` `.h` `.hpp` `.sh` `.rb` `.go` `.rs` `.swift` `.kt` | `exercises/` |
| `.png` `.jpg` `.jpeg` `.gif` `.svg` `.mp4` `.mp3` `.zip` `.tar` `.gz` | `resources/` |

Files with unknown extensions are left in place and reported in the output.

## Adding New Study Material

1. Drop files into the repository root (or any folder that makes sense to you).
2. Run `./scripts/sort_files.sh` to have them moved into the right folder automatically.
3. Commit the changes.
