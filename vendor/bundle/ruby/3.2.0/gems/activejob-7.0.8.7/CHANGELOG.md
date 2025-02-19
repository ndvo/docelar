## Rails 7.0.8.7 (December 10, 2024) ##

*   No changes.


## Rails 7.0.8.6 (October 23, 2024) ##

*   No changes.


## Rails 7.0.8.5 (October 15, 2024) ##

*   No changes.


## Rails 7.0.8.4 (June 04, 2024) ##

*   No changes.


## Rails 7.0.8.3 (May 17, 2024) ##

*   No changes.


## Rails 7.0.8.2 (May 16, 2024) ##

*   No changes.


## Rails 7.0.8.1 (February 21, 2024) ##

*   No changes.


## Rails 7.0.8 (September 09, 2023) ##

*   Fix Active Job log message to correctly report a job failed to enqueue
    when the adapter raises an `ActiveJob::EnqueueError`.

    *Ben Sheldon*


## Rails 7.0.7.2 (August 22, 2023) ##

*   No changes.


## Rails 7.0.7.1 (August 22, 2023) ##

*   No changes.


## Rails 7.0.7 (August 09, 2023) ##

*   No changes.


## Rails 7.0.6 (June 29, 2023) ##

*   Fix error Active Job passed class with `permitted?`.

    *Alex Baldwin*


## Rails 7.0.5.1 (June 26, 2023) ##

*   No changes.


## Rails 7.0.5 (May 24, 2023) ##

*   Make delayed job `display_name` failsafe.

    *codez*

*   Don't double log the `job` when using `ActiveRecord::QueryLog`

    Previously if you set `config.active_record.query_log_tags` to an array that included
    `:job`, the job name would get logged twice. This bug has been fixed.

    *Alex Ghiculescu*


## Rails 7.0.4.3 (March 13, 2023) ##

*   No changes.


## Rails 7.0.4.2 (January 24, 2023) ##

*   No changes.


## Rails 7.0.4.1 (January 17, 2023) ##

*   No changes.


## Rails 7.0.4 (September 09, 2022) ##

*   Update `ActiveJob::QueueAdapters::QueAdapter` to remove deprecation warning.

    Remove a deprecation warning introduced in que 1.2 to prepare for changes in
    que 2.0 necessary for Ruby 3 compatibility.

    *Damir Zekic* and *Adis Hasovic*

## Rails 7.0.3.1 (July 12, 2022) ##

*   No changes.


## Rails 7.0.3 (May 09, 2022) ##

*   Add missing `bigdecimal` require in `ActiveJob::Arguments`

    Could cause `uninitialized constant ActiveJob::Arguments::BigDecimal (NameError)`
    when loading Active Job in isolation.

    *Jean Boussier*

## Rails 7.0.2.4 (April 26, 2022) ##

*   No changes.


## Rails 7.0.2.3 (March 08, 2022) ##

*   No changes.


## Rails 7.0.2.2 (February 11, 2022) ##

*   No changes.


## Rails 7.0.2.1 (February 11, 2022) ##

*   No changes.


## Rails 7.0.2 (February 08, 2022) ##

*   No changes.


## Rails 7.0.1 (January 06, 2022) ##

*   Allow testing `discard_on/retry_on ActiveJob::DeserializationError`

    Previously in `perform_enqueued_jobs`, `deserialize_arguments_if_needed`
    was called before calling `perform_now`. When a record no longer exists
    and is serialized using GlobalID this led to raising
    an `ActiveJob::DeserializationError` before reaching `perform_now` call.
    This behaviour makes difficult testing the job `discard_on/retry_on` logic.

    Now `deserialize_arguments_if_needed` call is postponed to when `perform_now`
    is called.

    Example:

    ```ruby
    class UpdateUserJob < ActiveJob::Base
      discard_on ActiveJob::DeserializationError

      def perform(user)
        # ...
      end
    end

    # In the test
    User.destroy_all
    assert_nothing_raised do
      perform_enqueued_jobs only: UpdateUserJob
    end
    ```

    *Jacopo Beschi*


## Rails 7.0.0 (December 15, 2021) ##

*   No changes.


## Rails 7.0.0.rc3 (December 14, 2021) ##

*   No changes.


## Rails 7.0.0.rc2 (December 14, 2021) ##

*   No changes.

## Rails 7.0.0.rc1 (December 06, 2021) ##

*   Remove deprecated `:return_false_on_aborted_enqueue` option.

    *Rafael Mendonça França*

*   Deprecated `Rails.config.active_job.skip_after_callbacks_if_terminated`.

    *Rafael Mendonça França*

*   Removed deprecated behavior that was not halting `after_enqueue`/`after_perform` callbacks when a
    previous callback was halted with `throw :abort`.

    *Rafael Mendonça França*

*   Raise an `SerializationError` in `Serializer::ModuleSerializer`
    if the module name is not present.

    *Veerpal Brar*


## Rails 7.0.0.alpha2 (September 15, 2021) ##

*   No changes.


## Rails 7.0.0.alpha1 (September 15, 2021) ##

*   Allow a job to retry indefinitely

    The `attempts` parameter of the `retry_on` method now accepts the
    symbol reference `:unlimited` in addition to a specific number of retry
    attempts to allow a developer to specify that a job should retry
    forever until it succeeds.

        class MyJob < ActiveJob::Base
          retry_on(AlwaysRetryException, attempts: :unlimited)

          # the actual job code
        end

    *Daniel Morton*

*   Added possibility to check on `:priority` in test helper methods
    `assert_enqueued_with` and `assert_performed_with`.

    *Wojciech Wnętrzak*

*   OpenSSL constants are now used for Digest computations.

    *Dirkjan Bussink*

*   Add a Serializer for the Range class.

    This should allow things like `MyJob.perform_later(range: 1..100)`.

*   Communicate enqueue failures to callers of `perform_later`.

    `perform_later` can now optionally take a block which will execute after
    the adapter attempts to enqueue the job. The block will receive the job
    instance as an argument even if the enqueue was not successful.
    Additionally, `ActiveJob` adapters now have the ability to raise an
    `ActiveJob::EnqueueError` which will be caught and stored in the job
    instance so code attempting to enqueue jobs can inspect any raised
    `EnqueueError` using the block.

        MyJob.perform_later do |job|
          unless job.successfully_enqueued?
            if job.enqueue_error&.message == "Redis was unavailable"
              # invoke some code that will retry the job after a delay
            end
          end
        end

    *Daniel Morton*

*   Don't log rescuable exceptions defined with `rescue_from`.

    *Hu Hailin*

*   Allow `rescue_from` to rescue all exceptions.

    *Adrianna Chang*, *Étienne Barrié*


Please check [6-1-stable](https://github.com/rails/rails/blob/6-1-stable/activejob/CHANGELOG.md) for previous changes.
