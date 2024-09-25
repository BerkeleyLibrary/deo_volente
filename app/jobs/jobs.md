# job structure - questions and issues

* construction of a file object really depends on dataload/batch context. what's the best way to bring that in?
    * service object seems to be the way i'm leaning, but ... 
* what's the activejob/good_job idiom to get the right dependency sequence here? i.e., enumerate the files, build the datafile objects, run through 'em, etc.? 
    * the "complex batches" writeup in the good_job docs seems very conusing here 
* do we actually need the files in the database at all? (i think we do to materialize the batches to send them up to dataverse)

## original proposed job structure

```mermaid
flowchart
    start(["start(dir, doi)"]) --> walkDirectory["walkDirectory(dir)"]
        --> forEachFile --> fileSuccess{"success?"} -->|true| updateDataverse
        --> success{"success?"} -->|true| End(["end"]) 

    subgraph forEachFile["forEachFile (map)"]
        handleFile --> copyToDVStorage 

        subgraph handleFile["handleFile(filename)"]
            generateStorageIdentifier -->fileMetadata
            getPathname --> splitPathAndFileName & getMimeType & md5Hash --> fileMetadata[/"fileMetadata"/]
        end
        
        subgraph copyToDVStorage
            dest["dest = dvFilesDir + splitDoi + storageIdentifier"] -->
            copyFile["copyFile(source, dest)"] --> compareMD5["compareMD5(source, dest)"]
        end
    end

    subgraph updateDataverse["updateDataverse (reduce)"]
        direction TB
        note["presumes we send one blob of JSON for all files.
        could post single files or batches."]-.->
        prepareJSON --> postJSONToDataverse --> logDataverseFileID[(logDataverseFileID)]
    end

    fileSuccess -->|false| fileFail(["fail (file job)"]) -.-> Fail
    success -->|false| Fail(["fail (dataset job)"])
```