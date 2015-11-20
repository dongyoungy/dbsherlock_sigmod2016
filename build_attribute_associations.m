function [attribute_associations] = build_attribute_associations

	% cause attributes
	attribute_associations = {};

	association = struct();
	association.source = 'dbmsMeasuredCPU';
	association.target = {};
	association.target{end+1} = 'AvgCpuUser';
	association.target{end+1} = 'AvgCpuIdle';
	attribute_associations{end+1} = association;

	association = struct();
	association.source = 'osNumberOfReadsIssued';
	association.target = {};
	association.target{end+1} = 'osNumberOfSectorReads';
	association.target{end+1} = 'osDiskUtilization';
	attribute_associations{end+1} = association;

	association = struct();
	association.source = 'osNumberOfWritesCompleted';
	association.target = {};
	association.target{end+1} = 'osNumberOfSectorWrites';
	association.target{end+1} = 'osDiskUtilization';
	attribute_associations{end+1} = association;

	association = struct();
	association.source = 'dbmsThreadsRunning';
	association.target = {};
	association.target{end+1} = 'osNumberOfContextSwitches';
	association.target{end+1} = 'osNumberOfInterrupt';
	attribute_associations{end+1} = association;

	association = struct();
	association.source = 'dbmsNumberOfPhysicalLogWrites';
	association.target = {};
	association.target{end+1} = 'osDiskUtilization';
	association.target{end+1} = 'osNumberOfSectorWrites';
	attribute_associations{end+1} = association;

	association = struct();
	association.source = 'dbmsNumberOfDataReads';
	association.target = {};
	association.target{end+1} = 'osDiskUtilization';
	association.target{end+1} = 'osNumberOfSectorReads';
	attribute_associations{end+1} = association;

	association = struct();
	association.source = 'dbmsNumberOfDataWrites';
	association.target = {};
	association.target{end+1} = 'osDiskUtilization';
	association.target{end+1} = 'osNumberOfSectorWrites';
	attribute_associations{end+1} = association;

	association = struct();
	association.source = 'dbmsNumberOfLogWriteRequests';
	association.target = {};
	association.target{end+1} = 'osDiskUtilization';
	association.target{end+1} = 'osNumberOfSectorWrites';
	association.target{end+1} = 'dbmsNumberOfPhysicalLogWrites';
	attribute_associations{end+1} = association;

	association = struct();
	association.source = 'dbmsNumberOfFysncLogWrites';
	association.target = {};
	association.target{end+1} = 'osDiskUtilization';
	association.target{end+1} = 'osNumberOfSectorWrites';
	association.target{end+1} = 'dbmsNumberOfPhysicalLogWrites';
	attribute_associations{end+1} = association;

	association = struct();
	association.source = 'dbmsNumberOfNextRowReadRequests';
	association.target = {};
	association.target{end+1} = 'osDiskUtilization';
	association.target{end+1} = 'osNumberOfSectorReads';
	association.target{end+1} = 'dbmsNumberOfDataReads';
	association.target{end+1} = 'dbmsReadRequests';
	attribute_associations{end+1} = association;

	association = struct();
	association.source = 'dbmsNumberOfRowInsertRequests';
	association.target = {};
	association.target{end+1} = 'osDiskUtilization';
	association.target{end+1} = 'osNumberOfSectorWrites';
	association.target{end+1} = 'dbmsNumberOfDataWrites';
	attribute_associations{end+1} = association;

	association = struct();
	association.source = 'dbmsNumberOfFirstEntryReadRequests';
	association.target = {};
	association.target{end+1} = 'osDiskUtilization';
	association.target{end+1} = 'osNumberOfSectorReads';
	association.target{end+1} = 'dbmsNumberOfDataReads';
	association.target{end+1} = 'dbmsReadRequests';
	attribute_associations{end+1} = association;

	association = struct();
	association.source = 'dbmsNumberOfKeyBasedReadRequests';
	association.target = {};
	association.target{end+1} = 'osDiskUtilization';
	association.target{end+1} = 'osNumberOfSectorReads';
	association.target{end+1} = 'dbmsNumberOfDataReads';
	association.target{end+1} = 'dbmsReadRequests';
	attribute_associations{end+1} = association;

	association = struct();
	association.source = 'dbmsNumberOfNextKeyBasedReadRequests';
	association.target = {};
	association.target{end+1} = 'osDiskUtilization';
	association.target{end+1} = 'osNumberOfSectorReads';
	association.target{end+1} = 'dbmsNumberOfDataReads';
	association.target{end+1} = 'dbmsReadRequests';
	attribute_associations{end+1} = association;

	association = struct();
	association.source = 'dbmsNumberOfPrevKeyBasedReadRequests';
	association.target = {};
	association.target{end+1} = 'osDiskUtilization';
	association.target{end+1} = 'osNumberOfSectorReads';
	association.target{end+1} = 'dbmsNumberOfDataReads';
	association.target{end+1} = 'dbmsReadRequests';
	attribute_associations{end+1} = association;

	association = struct();
	association.source = 'dbmsPageWritesMB';
	association.target = {};
	association.target{end+1} = 'osDiskUtilization';
	association.target{end+1} = 'osNumberOfSectorWrites';
	attribute_associations{end+1} = association;

	association = struct();
	association.source = 'dbmsDoublePageWritesMB';
	association.target = {};
	association.target{end+1} = 'osDiskUtilization';
	association.target{end+1} = 'osNumberOfSectorWrites';
	attribute_associations{end+1} = association;

	association = struct();
	association.source = 'dbmsDoubleWritesOperations';
	association.target = {};
	association.target{end+1} = 'osDiskUtilization';
	association.target{end+1} = 'osNumberOfSectorWrites';
	attribute_associations{end+1} = association;

	association = struct();
	association.source = 'dbmsNumberOfLogicalReadsFromDisk';
	association.target = {};
	association.target{end+1} = 'osDiskUtilization';
	association.target{end+1} = 'osNumberOfSectorReads';
	attribute_associations{end+1} = association;

	association = struct();
	association.source = 'dbmsRandomReadAheads';
	association.target = {};
	association.target{end+1} = 'osDiskUtilization';
	association.target{end+1} = 'osNumberOfSectorReads';
	attribute_associations{end+1} = association;

	association = struct();
	association.source = 'dbmsSequentialReadAheads';
	association.target = {};
	association.target{end+1} = 'osDiskUtilization';
	association.target{end+1} = 'osNumberOfSectorReads';
	attribute_associations{end+1} = association;

    % 'AvgCpuUser'
    % 'AvgCpuSys'
    % 'AvgCpuIdle'
    % 'AvgCpuWai'
    % 'AvgCpuHiq'
    % 'AvgCpuSiq'
    % 'osAsynchronousIO'
    % 'osNumberOfContextSwitches'
    % 'osNumberOfSectorReads'
    % 'osNumberOfSectorWrites'
    % 'osAllocatedFileHandlers'
    % 'osAllocatedINodes'
    % 'osCountOfInterruptsServicedSinceBootTime'
    % 'osNumberOfInterrupt'
    % 'osInterruptCount1'
    % 'osInterruptCount2'
    % 'osInterruptCount3'
    % 'osNumberOfReadsIssued'
    % 'osNumberOfWritesCompleted'
    % 'osNumberOfSwapInSinceLastBoot'
    % 'osNumberOfSwapOutSinceLastBoot'
    % 'osNumberOfProcessesCreated'
    % 'osNumberOfProcessesCurrentlyRunning'
    % 'osDiskUtilization'
    % 'osFreeSwapSpace'
    % 'osUsedSwapSpace'
    % 'osNumberOfAllocatedPage'
    % 'osNumberOfFreePages'
    % 'osNumberOfMajorPageFaults'
    % 'osNumberOfMinorPageFaults'
    % 'osNetworkSendKB'
    % 'osNetworkRecvKB'
    % 'dbmsCumChangedRows'
    % 'dbmsCumFlushedPages'
    % 'dbmsFlushedPages'
    % 'dbmsCurrentDirtyPages'
    % 'dbmsDirtyPages'
    % 'dbmsDataPages'
    % 'dbmsFreePages'
    % 'dbmsTotalPages'
    % 'dbmsThreadsRunning'
    % 'dbmsTotalWritesMB'
    % 'dbmsLogWritesMB'
    % 'dbmsNumberOfPhysicalLogWrites'
    % 'dbmsNumberOfDataReads'
    % 'dbmsNumberOfDataWrites'
    % 'dbmsNumberOfLogWriteRequests'
    % 'dbmsNumberOfFysncLogWrites'
    % 'dbmsNumberOfPendingLogWrites'
    % 'dbmsNumberOfPendingLogFsyncs'
    % 'dbmsNumberOfNextRowReadRequests'
    % 'dbmsNumberOfRowInsertRequests'
    % 'dbmsNumberOfFirstEntryReadRequests'
    % 'dbmsNumberOfKeyBasedReadRequests'
    % 'dbmsNumberOfNextKeyBasedReadRequests'
    % 'dbmsNumberOfPrevKeyBasedReadRequests'
    % 'dbmsNumberOfRowReadRequests'
    % 'dbmsPageWritesMB'
    % 'dbmsDoublePageWritesMB'
    % 'dbmsDoubleWritesOperations'
    % 'dbmsNumberOfPendingWrites'
    % 'dbmsNumberOfPendingReads'
    % 'dbmsBufferPoolWrites'
    % 'dbmsRandomReadAheads'
    % 'dbmsSequentialReadAheads'
    % 'dbmsNumberOfLogicalReadRequests'
    % 'dbmsNumberOfLogicalReadsFromDisk'
    % 'dbmsNumberOfWaitsForFlush'
    % 'dbmsCommittedCommands'
    % 'dbmsRolledbackCommands'
    % 'dbmsRollbackHandler'
    % 'dbmsCurrentLockWaits'
    % 'dbmsLockWaits'
    % 'dbmsLockWaitTime'
    % 'dbmsReadRequests'
    % 'dbmsReads'
    % 'dbmsPhysicalReadsMB'
    % 'dbmsPageSize'
end
