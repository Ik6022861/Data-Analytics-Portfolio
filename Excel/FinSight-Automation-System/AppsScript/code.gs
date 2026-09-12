function ProcessUniversal() {

  // =====================================================
  // CONFIGURATION
  // =====================================================

  var SourceFolderId = YOUR_SOURCE_FOLDER_ID;
  var ArchiveFolderId = "YOUR_ARCHIVE_FOLDER_ID";


  // =====================================================
  // GET FOLDERS
  // =====================================================

  var sourceFolder = DriveApp.getFolderById(SourceFolderId);
  var archiveFolder = DriveApp.getFolderById(ArchiveFolderId);


  // =====================================================
  // GET MASTER SHEET
  // =====================================================

  var masterSheet = SpreadsheetApp
    .getActiveSpreadsheet()
    .getActiveSheet();


  // =====================================================
  // GET FILES FROM SOURCE FOLDER
  // =====================================================

  var files = sourceFolder.getFiles();


  // =====================================================
  // PROCESS EACH FILE
  // =====================================================

  while (files.hasNext()) {

    var file = files.next();

    var filename = file.getName();
    var mimetype = file.getMimeType();

    Logger.log(
      "Found file: " + filename +
      " | Type: " + mimetype
    );


    // This will contain the data from the current file
    var dataToCopy = [];


    // =================================================
    // SCENARIO 1: GOOGLE SHEETS
    // =================================================

    if (mimetype === MimeType.GOOGLE_SHEETS) {

      Logger.log(
        "Processing Google Sheet: " + filename
      );

      try {

        var sourceSpreadsheet = SpreadsheetApp
          .openById(file.getId());

        var sourceSheet = sourceSpreadsheet
          .getSheets()[0];

        dataToCopy = sourceSheet
          .getDataRange()
          .getValues();

      } catch (e) {

        Logger.log(
          "ERROR reading Google Sheet: " +
          filename +
          " | " +
          e.message
        );

        continue;
      }
    }


    // =================================================
    // SCENARIO 2: EXCEL FILE
    // =================================================

    else if (
      mimetype.indexOf("excel") > -1 ||
      mimetype.indexOf("spreadsheet") > -1 ||
      filename.toLowerCase().endsWith(".xlsx")
    ) {

      Logger.log(
        "Processing Excel file: " + filename
      );

      var tempfile = null;

      try {

        // ---------------------------------------------
        // Excel → Temporary Google Sheet
        // ---------------------------------------------

        var TempFileConfig = {

          name: "[TEMP] " + filename,

          mimeType: MimeType.GOOGLE_SHEETS,

          parents: [SourceFolderId]

        };


        tempfile = Drive.Files.create(
          TempFileConfig,
          file.getBlob()
        );


        Logger.log(
          "Temporary Google Sheet created: " +
          tempfile.id
        );


        // ---------------------------------------------
        // Open temporary Google Sheet
        // ---------------------------------------------

        var tempSpreadsheet = SpreadsheetApp
          .openById(tempfile.id);

        var tempSheet = tempSpreadsheet
          .getSheets()[0];


        // ---------------------------------------------
        // Read data
        // ---------------------------------------------

        dataToCopy = tempSheet
          .getDataRange()
          .getValues();


        Logger.log(
          "Rows found: " +
          dataToCopy.length +
          " | Columns found: " +
          (dataToCopy.length > 0
            ? dataToCopy[0].length
            : 0)
        );


      } catch (e) {

        Logger.log(
          "ERROR converting Excel file: " +
          filename +
          " | " +
          e.message
        );

        // If temporary file was created,
        // delete it even if something went wrong
        if (tempfile && tempfile.id) {

          try {

            DriveApp
              .getFileById(tempfile.id)
              .setTrashed(true);

          } catch (deleteError) {

            Logger.log(
              "Could not delete temporary file: " +
              deleteError.message
            );
          }
        }

        continue;
      }


      // ---------------------------------------------
      // Delete temporary Google Sheet
      // ---------------------------------------------

      if (tempfile && tempfile.id) {

        try {

          DriveApp
            .getFileById(tempfile.id)
            .setTrashed(true);

          Logger.log(
            "Temporary file deleted."
          );

        } catch (e) {

          Logger.log(
            "WARNING: Could not delete temporary file: " +
            e.message
          );
        }
      }
    }


    // =================================================
    // UNSUPPORTED FILE TYPE
    // =================================================

    else {

      Logger.log(
        "Skipped unsupported file: " +
        filename +
        " | Type: " +
        mimetype
      );

      continue;
    }


    // =================================================
    // CHECK WHETHER DATA EXISTS
    // =================================================

    if (
      !dataToCopy ||
      dataToCopy.length === 0 ||
      dataToCopy[0].length === 0
    ) {

      Logger.log(
        "Skipped: " +
        filename +
        " | No data found."
      );

      continue;
    }


    // =================================================
    // WRITE DATA TO MASTER SHEET
    // =================================================

    try {

      var masterLastRow = masterSheet.getLastRow();

      var masterLastColumn = masterSheet.getLastColumn();


      // =================================================
      // FIRST FILE
      // =================================================

      if (masterLastRow === 0) {

        Logger.log(
          "Master sheet is empty."
        );

        Logger.log(
          "Writing first file including header."
        );


        masterSheet
          .getRange(
            1,
            1,
            dataToCopy.length,
            dataToCopy[0].length
          )
          .setValues(dataToCopy);


        Logger.log(
          "Inserted " +
          dataToCopy.length +
          " rows."
        );
      }


      // =================================================
      // SECOND / THIRD / OTHER FILES
      // =================================================

      else {

        Logger.log(
          "Master sheet already contains " +
          masterLastRow +
          " rows."
        );


        // ---------------------------------------------
        // Remove header from current file
        // ---------------------------------------------

        var databody = dataToCopy.slice(1);


        // ---------------------------------------------
        // Make sure data remains after removing header
        // ---------------------------------------------

        if (databody.length === 0) {

          Logger.log(
            "Skipped: " +
            filename +
            " | File contains header only."
          );

          continue;
        }


        // ---------------------------------------------
        // Start after the last existing row
        // ---------------------------------------------

        var startRow = masterLastRow + 1;


        Logger.log(
          "Starting new data at row: " +
          startRow
        );


        // ---------------------------------------------
        // Write data
        // IMPORTANT: setValues(), NOT setValue()
        // ---------------------------------------------

        masterSheet
          .getRange(
            startRow,
            1,
            databody.length,
            databody[0].length
          )
          .setValues(databody);


        Logger.log(
          "Inserted " +
          databody.length +
          " rows starting at row " +
          startRow
        );
      }


      // =================================================
      // ARCHIVE FILE
      // =================================================

      file.moveTo(archiveFolder);


      Logger.log(
        "SUCCESS: Processed and archived: " +
        filename
      );


    } catch (e) {

      Logger.log(
        "ERROR pasting data for: " +
        filename +
        " | " +
        e.message
      );

      // IMPORTANT:
      // File will NOT be archived if writing failed.
      // Therefore you can fix the problem and run again.

      continue;
    }
  }


  // =====================================================
  // FINISHED
  // =====================================================

  Logger.log(
    "========================================"
  );

  Logger.log(
    "PROCESS COMPLETED"
  );

  Logger.log(
    "========================================"
  );
}