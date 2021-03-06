module Actions
  module Pulp
    module Repository
      class UpdateSchedule < Pulp::Abstract
        input_format do
          param :repo_id
          param :schedule
          param :enabled
        end

        def run
          repo = ::Katello::Repository.find(input[:repo_id])
          schedules = pulp_resources.repository_schedule.list(repo.pulp_id, repo.importer_type)

          params = {}
          params[:schedule] = input[:schedule] if input.key?(:schedule)
          params[:enabled] = input[:enabled] if input.key?(:enabled)

          if schedules.empty?
            output[:response] = create(repo, params)
          else
            schedule = schedules.first
            output[:response] = update(repo, schedule['_id'], params)
          end
        end

        def create(repo, params)
          pulp_resources.repository_schedule.create(
            repo.pulp_id,
            repo.importer_type,
            params[:schedule],
            params
          )
        end

        def update(repo, schedule_id, params)
          pulp_resources.repository_schedule.update(
            repo.pulp_id,
            repo.importer_type,
            schedule_id,
            params
          )
        end
      end
    end
  end
end
