import cosmoscripting

do_load = True
catalog_dir = '/home/greg/hera/cosmo/'
catalog_files = ['load_hera_001.json', 'sensor_HERA_AFC-1-DIDYMOS.json']
far_view = [0, 0, 0.21]
near_view = [0, 0, 16.5]
time_rate = 60 * 60

cosmo = cosmoscripting.Cosmo()
cosmo.setTimeRate(time_rate)
cosmo.setTime('2027-06-04 00:00:00.0001 UTC')
cosmo.displayNote('Simulation time set to the 4th June, 2027.', 2)
if do_load:
    for file in catalog_files:
        cosmo.loadCatalogFile(catalog_dir + file)
    cosmo.displayNote('Hera catalogs loaded successfully.', 2)

cosmo.selectObject('HERA')
cosmo.setCentralObject('HERA')
cosmo.moveToPov('HERA', far_view, [0, 0, 1], [0, 0, 1], 1)
cosmo.setCameraToLockedFrame('HERA')
cosmo.selectObject('DIDYMOS')
cosmo.unpause()

#cosmo.setVideoRecordingResolution('1080p')
#cosmo.startRecordingVideoToFile('/home/grego/sw/cosmographia-4.0/data/gallery/record_didymos.mp4')
#cosmo.wait(5)
#cosmo.stopRecordingVideo()
